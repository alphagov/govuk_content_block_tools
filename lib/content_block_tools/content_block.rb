module ContentBlockTools
  # Defines a Content Block
  #
  # @api public
  #
  # @!attribute [r] content_id
  #   The content UUID for a block
  #   @example
  #     content_block.id #=> "2b92cade-549c-4449-9796-e7a3957f3a86"
  #   @return [String]
  #
  # @!attribute [r] title
  #   A title for the content block
  #   @example
  #     content_block.title #=> "Some title"
  #   @return [String]
  #   @api public
  #
  # @!attribute [r] document_type
  #   The document type of the content block - this will be used to work out which Presenter
  #   will be used to render the content block. All supported document_types are documented in
  #   {ContentBlockTools::ContentBlockReference::SUPPORTED_DOCUMENT_TYPES}
  #   @example
  #     content_block.document_type #=> "content_block_pension"
  #   @return [String] the document type
  #   @api public
  #
  # @!attribute [r] details
  #  A hash that contains the details of the content block
  #  @example
  #   content_block.details #=> { email_address: "foo@example.com" }
  #  @return [Hash] the details
  #  @api public
  #
  # @!attribute [r] embed_code
  #  The embed_code used for a block containing optional field name
  #  @example
  #    content_block_reference.embed_code #=> "{{embed:content_block_pension:2b92cade-549c-4449-9796-e7a3957f3a86}}"
  #    content_block_reference.embed_code #=> "{{embed:content_block_contact:2b92cade-549c-4449-9796-e7a3957f3a86/field_name}}"
  #  @return [String]
  #
  # @!attribute [r] format
  #  The format specifier from the embed code, used to control rendering output
  #  @example
  #    content_block.format #=> "years_short"
  #  @return [String]
  class ContentBlock
    CONTENT_BLOCK_PREFIX = "content_block_".freeze

    attr_reader :content_id, :title, :embed_code

    def initialize(content_id:, title:, document_type:, details:, embed_code:)
      @content_id = content_id
      @title = title
      @document_type = document_type
      @details = details
      @embed_code = embed_code
    end

    # Renders the content block to HTML using the appropriate component or presenter
    #
    # @return [String] A HTML representation of the content block
    # @see Renderer
    def render
      Renderer.new(self).render
    end

    def details
      @details.deep_symbolize_keys
    end

    def document_type
      @document_type.delete_prefix(CONTENT_BLOCK_PREFIX)
    end

    def format
      EmbedCode.new(embed_code).format
    end
  end
end
