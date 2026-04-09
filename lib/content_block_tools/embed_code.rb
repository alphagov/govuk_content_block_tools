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
  #   embed_code.format #=> "years_short"
  #
  class EmbedCode
    FORMAT_MATCHER = /\|(?<format>\S+)}}$/

    # @param embed_code [String] The raw embed code string
    def initialize(embed_code)
      @embed_code = embed_code
      @matched_field_names = match_field_names
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

    # Extracts the format specifier from the embed code.
    #
    # @return [String] The format name, or Format::DEFAULT_FORMAT if none specified
    #
    # @example
    #   EmbedCode.new("{{embed:content_block_time_period:tax-year|years_short}}").format
    #   #=> "years_short"
    #
    #   EmbedCode.new("{{embed:content_block_time_period:tax-year}}").format
    #   #=> "default"
    #
    def format
      @format ||= parse_format
    end

  private

    attr_reader :embed_code

    def parse_field_names
      return nil unless @matched_field_names

      @matched_field_names.split("/").map do |item|
        numeric?(item) ? item.to_i : item.to_sym
      end
    end

    def match_field_names
      match = ContentBlockReference::EMBED_REGEX.match(embed_code)
      return unless match && match[:fields]

      stripped_of_trailing_or_leading_slashes(match[:fields])
    end

    def stripped_of_trailing_or_leading_slashes(string)
      string.sub(%r{^/}, "").sub(%r{/$}, "")
    end

    def parse_format
      match = FORMAT_MATCHER.match(embed_code)
      return Format::DEFAULT_FORMAT unless match

      match[:format]
    end

    def numeric?(item)
      Float(item, exception: false)
    end
  end
end
