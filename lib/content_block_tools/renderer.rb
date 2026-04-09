module ContentBlockTools
  # Handles rendering of ContentBlock instances to HTML
  #
  # The Renderer is responsible for:
  # - Resolving the appropriate component or presenter for a content block
  # - Generating the HTML wrapper with appropriate data attributes
  # - Handling field-specific rendering when embed codes target specific fields
  #
  # @api private
  class Renderer
    include ActionView::Helpers::TagHelper

    class UnknownComponentError < StandardError; end

    # Creates a new Renderer for the given content block
    #
    # @param content_block [ContentBlock] The content block to render
    def initialize(content_block)
      @content_block = content_block
    end

    # Renders the content block to HTML
    #
    # @return [String] HTML representation of the content block
    def render
      content_tag(
        base_tag,
        content,
        class: %W[content-block content-block--#{document_type}],
        data: {
          content_block: "",
          document_type: document_type,
          content_id: content_id,
          embed_code: embed_code,
        },
      )
    end

  private

    attr_reader :content_block

    delegate :content_id, :title, :embed_code, :details, :document_type, :format,
             to: :content_block

    def base_tag
      rendering_block? ? :div : :span
    end

    def content
      if field_names.present?
        field_or_block_content
      else
        component.new(content_block: content_block).render
      end
    rescue UnknownComponentError
      title
    end

    def field_or_block_content
      field_content = details.dig(*field_names)

      case field_content
      when String
        field_presenter(field_names.last).new(field_content).render
      when Hash
        render_hash_content
      else
        log_missing_content_warning
        embed_code
      end
    end

    def render_hash_content
      if embedded_object_in_one_to_one_relationship?
        field_presenter(field_names.last).new(details.dig(*field_names)).render
      else
        component.new(
          content_block: content_block,
          block_type: field_names.first,
          block_name: field_names.last,
        ).render
      end
    end

    def log_missing_content_warning
      ContentBlockTools.logger.warn(
        "Content not found for content block #{content_id} and fields #{field_names}",
      )
    end

    def embedded_object_in_one_to_one_relationship?
      field_names.one?
    end

    def rendering_block?
      !field_names.present? || details.dig(*field_names).is_a?(Hash)
    end

    def component
      "ContentBlockTools::#{document_type.camelize}Component".constantize
    rescue NameError
      raise UnknownComponentError
    end

    def field_presenter(field)
      presenter_class_name =
        "ContentBlockTools::Presenters::FieldPresenters::" \
        "#{document_type.camelize}::#{field.to_s.camelize}Presenter"
      presenter_class_name.constantize
    rescue NameError
      ContentBlockTools::Presenters::FieldPresenters::BasePresenter
    end

    def field_names
      @field_names ||= EmbedCode.new(embed_code).field_names
    end
  end
end
