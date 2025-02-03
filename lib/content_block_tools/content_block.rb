module ContentBlockTools
  ContentBlock = Data.define(:content_id, :title, :document_type, :details, :embed_code)

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
  #     content_block.document_type #=> "content_block_email_address"
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
  #   @example
  #     content_block_reference.embed_code #=> "{{embed:content_block_email_address:2b92cade-549c-4449-9796-e7a3957f3a86}}"
  #     content_block_reference.embed_code #=> "{{embed:content_block_postal_address:2b92cade-549c-4449-9796-e7a3957f3a86/field_name}}"
  #   @return [String]
  class ContentBlock < Data
    # A lookup of presenters for particular content block types
    CONTENT_PRESENTERS = {
      "content_block_email_address" => ContentBlockTools::Presenters::EmailAddressPresenter,
    }.freeze

    # Calls the appropriate presenter class to return a HTML representation of a content
    # block. Defaults to {Presenters::BasePresenter}
    #
    # @return [string] A HTML representation of the content block
    def render
      CONTENT_PRESENTERS
        .fetch(document_type, Presenters::BasePresenter)
        .new(self).render
    end

    def details
      to_h[:details].symbolize_keys
    end
  end
end
