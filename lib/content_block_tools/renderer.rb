module ContentBlockTools
  # Renders a ContentBlock to HTML
  #
  # This class encapsulates the logic for rendering a content block,
  # including determining the appropriate component or presenter to use
  # and wrapping the result in the standard content block markup.
  #
  # @example
  #   content_block = ContentBlock.new(...)
  #   html = Renderer.new(content_block).render
  #
  class Renderer
    include ActionView::Helpers::TagHelper

    class UnknownComponentError < StandardError; end

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
        class: %W[content-block content-block--#{content_block.document_type}],
        data: {
          content_block: "",
          document_type: content_block.document_type,
          content_id: content_block.content_id,
          embed_code: content_block.embed_code,
        },
      )
    end

  private

    attr_reader :content_block

    def base_tag
      rendering_block? ? :div : :span
    end

    def content
      field_names.present? ? field_or_block_content : component.new(content_block:).render
    rescue UnknownComponentError
      content_block.title
    end

    def field_or_block_content
      field_content = content_block.details.dig(*field_names)

      case field_content
      when String
        field_presenter(field_names.last).new(field_content).render
      when Hash
        render_hash_content(field_content)
      else
        log_content_not_found
        content_block.embed_code
      end
    end

    def render_hash_content(field_content)
      if embedded_object_in_one_to_one_relationship?
        field_presenter(field_names.last).new(field_content).render
      else
        component.new(
          content_block:,
          block_type: field_names.first,
          block_name: field_names.last,
        ).render
      end
    end

    def log_content_not_found
      ContentBlockTools.logger.warn(
        "Content not found for content block #{content_block.content_id} and fields #{field_names}",
      )
    end

    def embedded_object_in_one_to_one_relationship?
      field_names.one?
    end

    def rendering_block?
      !field_names.present? || content_block.details.dig(*field_names).is_a?(Hash)
    end

    def component
      "ContentBlockTools::#{content_block.document_type.camelize}Component".constantize
    rescue NameError
      raise UnknownComponentError
    end

    def field_presenter(field)
      presenter_class_name = "ContentBlockTools::Presenters::FieldPresenters::" \
                             "#{content_block.document_type.camelize}::#{field.to_s.camelize}Presenter"
      presenter_class_name.constantize
    rescue NameError
      ContentBlockTools::Presenters::FieldPresenters::BasePresenter
    end

    def field_names
      @field_names ||= EmbedCode.new(content_block.embed_code).field_names
    end
  end
end
