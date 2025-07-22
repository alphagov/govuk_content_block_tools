module ContentBlockTools
  ContentBlockReference = Data.define(:document_type, :identifier, :embed_code)

  # Defines a reference pointer for a Content Block
  #
  # @api public
  # @!attribute [r] document_type
  #   The document type of the content block - this will be used to work out which Presenter
  #   will be used to render the content block. All supported document_types are documented in
  #   {ContentBlockTools::ContentBlockReference::SUPPORTED_DOCUMENT_TYPES}
  #   @example
  #     content_block_reference.document_type #=> "content_block_pension"
  #   @return [String] the document type
  #   @api public
  #
  # @!attribute [r] identifier
  #   The identifier for a block - can be a UUID or a slug. The UUID will refer to the `content_id` of a block
  #   within Publishing API, while the slug will refer to a block's Content ID alias.
  #   @example
  #     content_block_reference.identifier #=> "2b92cade-549c-4449-9796-e7a3957f3a86"
  #     content_block_reference.identifier #=> "some-slug"
  #   @return [String]
  #
  # @!attribute [r] embed_code
  #   The embed_code used for a block
  #   @example
  #     content_block_reference.embed_code #=> "{{embed:content_block_pension:2b92cade-549c-4449-9796-e7a3957f3a86}}"
  #   @return [String]
  class ContentBlockReference < Data
    # An array of the supported document types
    SUPPORTED_DOCUMENT_TYPES = %w[contact content_block_pension content_block_contact].freeze
    # The regex used to find UUIDs
    UUID_REGEX = /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
    # The regex used to find content ID aliases
    CONTENT_ID_ALIAS_REGEX = /[a-z0-9\-–—]+/
    # The regex to find optional field names after the UUID, begins with '/'
    FIELD_REGEX = /(\/[a-z0-9_\-–—\/]*)?/
    # The regex used when scanning a document using {ContentBlockTools::ContentBlockReference.find_all_in_document}
    EMBED_REGEX = /({{embed:(#{SUPPORTED_DOCUMENT_TYPES.join('|')}):(#{UUID_REGEX}|#{CONTENT_ID_ALIAS_REGEX})#{FIELD_REGEX}}})/

    # Returns if the identifier is an alias
    #
    # @return Boolean
    def identifier_is_alias?
      !identifier.match?(UUID_REGEX)
    end

    class << self
      # Finds all content block references within a document, using `ContentBlockReference::EMBED_REGEX`
      # to scan through the document
      #
      # @return [Array<ContentBlockReference>] An array of content block references
      def find_all_in_document(document)
        document.scan(ContentBlockReference::EMBED_REGEX).map do |match|
          match = prepare_match(match)
          ContentBlockTools.logger.info("Found Content Block Reference: #{match}")
          ContentBlockReference.new(document_type: match[1], identifier: match[2], embed_code: match[0])
        end
      end

    private

      # This replaces an en / em dashes in content block references with double or triple dashes. This can occur
      # because Kramdown (the markdown parser that Govspeak is based on) replaces double dashes with en dashes and
      # triple dashes with em dashes
      def prepare_match(match)
        [
          replace_dashes(match[0]),
          match[1],
          replace_dashes(match[2]),
          match[3],
        ]
      end

      def replace_dashes(value)
        value&.gsub("–", "--")
          &.gsub("—", "---")
      end
    end
  end
end
