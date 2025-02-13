module ContentBlockTools
  ContentBlockReference = Data.define(:document_type, :content_id, :embed_code)

  # Defines a reference pointer for a Content Block
  #
  # @api public
  # @!attribute [r] document_type
  #   The document type of the content block - this will be used to work out which Presenter
  #   will be used to render the content block. All supported document_types are documented in
  #   {ContentBlockTools::ContentBlockReference::SUPPORTED_DOCUMENT_TYPES}
  #   @example
  #     content_block_reference.document_type #=> "content_block_email_address"
  #   @return [String] the document type
  #   @api public
  #
  # @!attribute [r] content_id
  #   The content UUID for a block
  #   @example
  #     content_block_reference.id #=> "2b92cade-549c-4449-9796-e7a3957f3a86"
  #   @return [String]
  #
  # @!attribute [r] embed_code
  #   The embed_code used for a block
  #   @example
  #     content_block_reference.embed_code #=> "{{embed:content_block_email_address:2b92cade-549c-4449-9796-e7a3957f3a86}}"
  #   @return [String]
  class ContentBlockReference < Data
    # An array of the supported document types
    SUPPORTED_DOCUMENT_TYPES = %w[contact content_block_email_address content_block_postal_address content_block_pension].freeze
    # The regex used to find UUIDs
    UUID_REGEX = /([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})/
    # The regex to find optional field names after the UUID, begins with '/'
    FIELD_REGEX = /(\/[a-z0-9_\-\/]*)?/
    # The regex used when scanning a document using {ContentBlockTools::ContentBlockReference.find_all_in_document}
    EMBED_REGEX = /({{embed:(#{SUPPORTED_DOCUMENT_TYPES.join('|')}):#{UUID_REGEX}#{FIELD_REGEX}}})/

    class << self
      # Finds all content block references within a document, using `ContentBlockReference::EMBED_REGEX`
      # to scan through the document
      #
      # @return [Array<ContentBlockReference>] An array of content block references
      def find_all_in_document(document)
        document.scan(ContentBlockReference::EMBED_REGEX).map do |match|
          ContentBlockReference.new(document_type: match[1], content_id: match[2], embed_code: match[0])
        end
      end
    end
  end
end
