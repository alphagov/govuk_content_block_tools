module ContentBlockTools
  module Renderers
    # Renders a specific field from a content block using the appropriate presenter.
    class FieldRenderer
      attr_reader :content_block, :keys_from_embed_code

      # Maps document types and field keys to specific presenter classes.
      FIELD_PRESENTERS = {
        contact: {
          email_addresses: {
            email_address: ContentBlockTools::Presenters::FieldPresenters::Contact::EmailAddressPresenter,
          },
        },
      }.freeze

      # Initializes a new FieldRenderer.
      #
      # @param content_block [Object] The content block containing field data and metadata.
      def initialize(content_block)
        @content_block = content_block
        @keys_from_embed_code = content_block.keys_from_embed_code
      end

      # Renders the field content using the appropriate presenter.
      #
      # @return [String] The rendered content, or the embed code if content is not found.
      def render
        content = content_block.details.deep_symbolize_keys.dig(*keys_from_embed_code)

        if content.blank?
          ContentBlockTools.logger.warn(
            "Content not found for content block #{content_block.content_id} and fields #{keys_from_embed_code}",
          )
          content_block.embed_code
        else
          field_presenter.new(content).render
        end
      end

    private

      # Looks up the presenter class for the current field.
      #
      # @return [Class] The presenter class to use.
      def field_presenter
        @field_presenter ||= FIELD_PRESENTERS.dig(*presenter_lookup) ||
          ContentBlockTools::Presenters::FieldPresenters::BasePresenter
      end

      # Builds the lookup path into FIELD_PRESENTERS based on document type and embed keys.
      #
      # @return [Array<Symbol>] The path to use for fetching the presenter class.
      def presenter_lookup
        if keys_from_embed_code.count == 1
          [content_block.document_type.to_sym, keys_from_embed_code.first]
        else
          [content_block.document_type.to_sym, keys_from_embed_code.first, keys_from_embed_code.last]
        end
      end
    end
  end
end
