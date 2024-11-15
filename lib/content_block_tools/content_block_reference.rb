module ContentBlockTools
  class ContentBlockReference < Data.define(:document_type, :content_id, :embed_code)
    SUPPORTED_DOCUMENT_TYPES = %w[contact content_block_email_address].freeze
    UUID_REGEX = /([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})/
    EMBED_REGEX = /({{embed:(#{SUPPORTED_DOCUMENT_TYPES.join('|')}):#{UUID_REGEX}}})/
  end
end
