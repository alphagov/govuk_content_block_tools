module ContentBlockTools
  module Presenters
    class BasePresenter
      include ActionView::Context
      include ActionView::Helpers::TagHelper

      # The default HTML tag to wrap the presented response in - can be overridden in a subclass
      BASE_TAG_TYPE = :span

      # A lookup of presenters for particular fields - can be overridden in a subclass
      FIELD_PRESENTERS = {}.freeze

      # A lookup of presenters for particular blocks - can be overridden in a subclass
      BLOCK_PRESENTERS = {}.freeze

      def self.has_embedded_objects(*object_types)
        @embedded_objects = object_types

        object_types.each do |object_type|
          define_method(object_type) do
            embedded_objects_of_type(object_type)
          end
        end
      end

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
          class: %W[content-block content-block--#{document_type}],
          data: {
            content_block: "",
            document_type: document_type,
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
        field_names.present? ? content_for_field_names : default_content
      end

      def default_content
        content_block.title
      end

      def content_for_field_names
        if field_or_block_content.blank?
          ContentBlockTools.logger.warn("Content not found for content block #{content_block.content_id} and fields #{field_names}")
          return content_block.embed_code
        end

        field_or_block_presenter.new(field_or_block_content, rendering_context: :field_names, content_block:).render
      end

      def field_names
        @field_names ||= begin
          embed_code_match = ContentBlockReference::EMBED_REGEX.match(content_block.embed_code)
          if embed_code_match.present?
            all_fields = embed_code_match[4]&.reverse&.chomp("/")&.reverse
            all_fields&.split("/")&.map do |item|
              is_number?(item) ? item.to_i : item.to_sym
            end
          end
        end
      end

      def is_number?(item)
        Float(item, exception: false)
      end

      def field_or_block_content
        @field_or_block_content ||= field_names.any? ? content_block.details.deep_symbolize_keys.dig(*field_names) : nil
      end

      def rendering_block?
        field_or_block_content.is_a?(Hash)
      end

      def field_or_block_presenter
        @field_or_block_presenter ||= if rendering_block?
                                        block_presenter || ContentBlockTools::Presenters::BlockPresenters::BasePresenter
                                      else
                                        field_presenter || ContentBlockTools::Presenters::FieldPresenters::BasePresenter
                                      end
      end

      def field_presenter
        @field_presenter ||= field_names ? self.class::FIELD_PRESENTERS[field_names.last] : nil
      end

      def block_presenter
        @block_presenter ||= field_names ? self.class::BLOCK_PRESENTERS[field_names.first] : nil
      end

      def base_tag
        field_names ? field_or_block_presenter::BASE_TAG_TYPE : self.class::BASE_TAG_TYPE
      end

      def embedded_objects_of_type(type)
        content_block.details.fetch(type, {}).values
      end

      def embedded_objects
        self.class.instance_variable_get("@embedded_objects")
      end

      def document_type
        content_block.document_type.delete_prefix("content_block_")
      end
    end
  end
end
