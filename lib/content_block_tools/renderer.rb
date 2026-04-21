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
      internal_content_path.present? ? field_or_block_content : component.new(content_block:).render
    rescue UnknownComponentError
      content_block.title
    end

    def field_or_block_content
      field_content = content_block.details.dig(*internal_content_path.path)

      case field_content
      when String
        field_presenter(internal_content_path.block_name).new(field_content).render
      when Hash
        render_hash_content(field_content)
      else
        log_content_not_found
        content_block.embed_code
      end
    end

    def render_hash_content(field_content)
      if internal_content_path.singular?
        field_presenter(internal_content_path.block_name).new(field_content).render
      else
        component.new(
          content_block:,
          block_type: internal_content_path.block_type,
          block_name: internal_content_path.block_name,
        ).render
      end
    end

    def log_content_not_found
      ContentBlockTools.logger.warn(
        "Content not found for content block #{content_block.content_id} " \
        "and fields #{internal_content_path.path}",
      )
    end

    def rendering_block?
      !internal_content_path.present? || content_block.details.dig(*internal_content_path.path).is_a?(Hash)
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

    def internal_content_path
      @internal_content_path ||= EmbedCode.new(content_block.embed_code).internal_content_path
    end
  end
end
