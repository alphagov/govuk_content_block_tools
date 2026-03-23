# frozen_string_literal: true

module ContentBlockTools
  # Parses an embed code string and extracts its components.
  #
  # An embed code has the format:
  #   {{embed:document_type:identifier/field/path|format}}
  #
  # Where:
  # - document_type: The type of content block (e.g., content_block_time_period)
  # - identifier: A UUID or slug identifying the content block
  # - /field/path: Optional path to a specific field within the content block
  # - |format: Optional format specifier for rendering
  #
  # @example
  #   embed_code = EmbedCode.new("{{embed:content_block_contact:my-contact/email_addresses/primary/email}}")
  #   embed_code.field_names #=> [:email_addresses, :primary, :email]
  #
  # @example With format
  #   embed_code = EmbedCode.new("{{embed:content_block_time_period:tax-year|years_short}}")
  #   embed_code.field_names #=> nil
  #
  class EmbedCode
    # @param embed_code [String] The raw embed code string
    def initialize(embed_code)
      @embed_code = embed_code
    end

    # Extracts the field path from the embed code.
    #
    # Parses the embed code to extract any field references after the identifier.
    # Field references are separated by '/' and can be either symbols or integers
    # (for array indexing).
    #
    # @return [Array<Symbol, Integer>, nil] An array of field names/indices,
    #   or nil if no fields are specified
    #
    # @example
    #   EmbedCode.new("{{embed:content_block_contact:id/emails/0/address}}").field_names
    #   #=> [:emails, 0, :address]
    #
    def field_names
      @field_names ||= parse_field_names
    end

  private

    attr_reader :embed_code

    def parse_field_names
      match = ContentBlockReference::EMBED_REGEX.match(embed_code)
      return nil unless match

      raw_fields = match[4]
      return nil if raw_fields.blank?

      # Remove leading slash and any trailing slash
      cleaned_fields = raw_fields.sub(%r{^/}, "").sub(%r{/$}, "")
      return nil if cleaned_fields.blank?

      cleaned_fields.split("/").map do |item|
        numeric?(item) ? item.to_i : item.to_sym
      end
    end

    def numeric?(item)
      Float(item, exception: false)
    end
  end
end
