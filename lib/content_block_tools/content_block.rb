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
  class ContentBlock
    include ActionView::Helpers::TagHelper
    class UnknownComponentError < StandardError; end

    CONTENT_BLOCK_PREFIX = "content_block_".freeze

    attr_reader :content_id, :title, :embed_code

    # Creates a ContentBlock instance from an embed code string by fetching
    # the content item data from the Content Store API.
    #
    # @param embed_code [String] The embed code string to parse and fetch content for
    #   @example
    #     ContentBlock.from_embed_code("{{embed:content_block_pension:2b92cade-549c-4449-9796-e7a3957f3a86}}")
    #
    # @return [ContentBlock] A new ContentBlock instance populated with data from the Content Store
    #
    # @raise [ContentBlockTools::InvalidEmbedCodeError] if the embed code format is invalid
    # @raise [GdsApi::HTTPErrorResponse] if the API request fails
    #
    # @example Create a ContentBlock from an embed code
    #   embed_code = "{{embed:content_block_email:123e4567-e89b-12d3-a456-426614174000}}"
    #   content_block = ContentBlock.from_embed_code(embed_code)
    #   content_block.title #=> "Contact Email"
    #   content_block.document_type #=> "email"
    #
    # @see ContentBlockReference.from_string
    # @see GdsApi.content_store
    def self.from_embed_code(embed_code)
      reference = ContentBlockReference.from_string(embed_code)
      api_response = GdsApi.content_store.content_item(reference.content_store_identifier)
      new(
        content_id: api_response["content_id"],
        title: api_response["title"],
        document_type: api_response["document_type"],
        details: api_response["details"],
        embed_code:,
      )
    end

    def initialize(content_id:, title:, document_type:, details:, embed_code:)
      @content_id = content_id
      @title = title
      @document_type = document_type
      @details = details
      @embed_code = embed_code
    end

    # Calls the appropriate presenter class to return a HTML representation of a content
    # block. Defaults to {Presenters::BasePresenter}
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
          content_id: content_id,
          embed_code: embed_code,
        },
      )
    end

    def details
      @details.deep_symbolize_keys
    end

    def document_type
      @document_type.delete_prefix(CONTENT_BLOCK_PREFIX)
    end

  private

    def base_tag
      rendering_block? ? :div : :span
    end

    def content
      field_names.present? ? field_or_block_content : component.new(content_block: self).render
    rescue UnknownComponentError
      title
    end

    def field_or_block_content
      content = details.dig(*field_names)
      case content
      when String
        field_presenter(field_names.last).new(content).render
      when Hash
        component.new(content_block: self, block_type: field_names.first, block_name: field_names.last).render
      else
        ContentBlockTools.logger.warn("Content not found for content block #{content_id} and fields #{field_names}")
        embed_code
      end
    end

    def rendering_block?
      !field_names.present? || details.dig(*field_names).is_a?(Hash)
    end

    def component
      "ContentBlockTools::#{document_type.camelize}Component".constantize
    rescue NameError
      raise UnknownComponentError
    end

    def field_presenter(field)
      "ContentBlockTools::Presenters::FieldPresenters::#{document_type.camelize}::#{field.to_s.camelize}Presenter".constantize
    rescue NameError
      ContentBlockTools::Presenters::FieldPresenters::BasePresenter
    end

    def field_names
      @field_names ||= begin
        embed_code_match = ContentBlockReference::EMBED_REGEX.match(embed_code)
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
  end
end
