module ContentBlockTools
  module Presenters
    class BasePresenter
      include ActionView::Context
      include ActionView::Helpers::TagHelper

      # The default HTML tag to wrap the presented response in - can be overridden in a subclass
      BASE_TAG_TYPE = :span

      # A lookup of presenters for particular fields - can be overridden in a subclass
      FIELD_PRESENTERS = {}.freeze

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
      # by overriding the content, default_content or the output of the FieldRenderer class
      #
      # @return [string] A representation of the content block to be wrapped in the base_tag in
      # {#content}
      def content
        ContentBlockTools.logger.info("Getting content for content block #{content_block.content_id}")
        if content_block.keys_from_embed_code.present?
          ContentBlockTools::Renderers::FieldRenderer.new(content_block).render
        else
          default_content
        end
      end

      def base_tag
        content_block.keys_from_embed_code ? :span : self.class::BASE_TAG_TYPE
      end

      def embedded_objects_of_type(type)
        content_block.details.fetch(type, {}).values
      end

      def embedded_objects
        self.class.instance_variable_get("@embedded_objects")
      end
    end
  end
end
