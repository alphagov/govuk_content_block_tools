module ContentBlockTools
  module Presenters
    class BasePresenter
      include ActionView::Context
      include ActionView::Helpers::TagHelper

      # The default HTML tag to wrap the presented response in - can be overridden in a subclass
      BASE_TAG_TYPE = :span

      # A lookup of presenters for particular fields - can be overridden in a subclass
      FIELD_PRESENTERS = {}.freeze

      # Returns a new presenter object
      #
      # @param [{ContentBlockTools::ContentBlock}] content_block  A content block object
      #
      # @return [{ContentBlockTools::Presenters::BasePresenter}]
      def initialize(content_block)
        @content_block = content_block
      end

      # Returns a HTML representation of the content block wrapped in a base tag with
      # a class and data attributes
      # Calls the {#content} method, which can be overridden in a subclass
      #
      # @return [string] A HTML representation of the content block
      def render
        content_tag(
          base_tag,
          content,
          class: %W[content-embed content-embed__#{content_block.document_type}],
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

      # The default representation of the content block - this can be overridden in a subclass
      # by overriding the content, default_content or content_for_fields methods
      #
      # @return [string] A representation of the content block to be wrapped in the base_tag in
      # {#content}
      def content
        ContentBlockTools.logger.info("Getting content for content block #{content_block.content_id}")
        if field_names.present?
          content_for_fields
        else
          default_content
        end
      end

      def default_content
        content_block.title
      end

      def content_for_fields
        content = content_block.details.deep_symbolize_keys.dig(*field_names)
        if content.blank?
          ContentBlockTools.logger.warn("Content not found for content block #{content_block.content_id} and fields #{field_names}")
          content_block.embed_code
        else
          presenter = field_presenter || ContentBlockTools::Presenters::FieldPresenters::BasePresenter
          presenter.new(content).render
        end
      end

      def field_names
        @field_names ||= begin
          embed_code_match = ContentBlockReference::EMBED_REGEX.match(content_block.embed_code)
          if embed_code_match.present?
            all_fields = embed_code_match[4]&.reverse&.chomp("/")&.reverse
            all_fields&.split("/")&.map(&:to_sym)
          end
        end
      end

      def field_presenter
        @field_presenter ||= field_names ? self.class::FIELD_PRESENTERS[field_names.last] : nil
      end

      def base_tag
        field_names ? :span : self.class::BASE_TAG_TYPE
      end
    end
  end
end
