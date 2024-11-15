module ContentBlockTools
  class ContentBlockReference < Data.define(:document_type, :content_id, :embed_code)
    SUPPORTED_DOCUMENT_TYPES = %w[contact content_block_email_address].freeze
    UUID_REGEX = /([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})/
    EMBED_REGEX = /({{embed:(#{SUPPORTED_DOCUMENT_TYPES.join('|')}):#{UUID_REGEX}}})/

    class << self
      # Finds all content block references within a document, using `ContentBlockReference::EMBED_REGEX`
      # to scan through the document
      #
      # @return [Array<ContentBlockReference>] An array of content block references
      def find_all_in_document(document)
        document.scan(ContentBlockReference::EMBED_REGEX).map { |match|
          ContentBlockReference.new(document_type: match[1], content_id: match[2], embed_code: match[0])
        }.uniq
      end
    end
  end
end
