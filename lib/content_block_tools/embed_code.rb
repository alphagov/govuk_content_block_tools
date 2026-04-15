module ContentBlockTools
  # Parses and represents an embed code string
  #
  # An embed code identifies a content block and optionally specifies which
  # fields to render and what format to use. The format is:
  #   {{embed:block_type:identifier}}
  #   {{embed:block_type:identifier/field1/nested_field2}}
  #   {{embed:block_type:identifier|format}}
  #   {{embed:block_type:identifier/field1|format}}
  #
  # @example Basic embed code
  #   embed_code = EmbedCode.new("{{embed:content_block_contact:main-office}}")
  #   embed_code.field_names #=> nil
  #   embed_code.format #=> "default"
  #
  # @example Embed code with field path
  #   embed_code = EmbedCode.new("{{embed:content_block_contact:main-office/email_addresses/main}}")
  #   embed_code.field_names #=> [:email_addresses, :main]
  #
  # @example Embed code with format
  #   embed_code = EmbedCode.new("{{embed:content_block_time_period:tax-year|years_short}}")
  #   embed_code.format #=> "years_short"
  #
  class EmbedCode
    FORMAT_REGEX = /\|(?<format>[^}]+)}}$/

    def initialize(embed_code_string)
      @embed_code_string = embed_code_string
    end

    # Returns the field names extracted from the embed code path
    #
    # Field names are the path components after the identifier, converted to symbols
    # or integers as appropriate.
    #
    # @return [Array<Symbol, Integer>, nil] The field names, or nil if no match
    def field_names
      @field_names ||= parse_field_names
    end

    # Returns the format specifier from the embed code
    #
    # @return [String] The format name, or Format::DEFAULT_FORMAT if none specified
    def format
      @format ||= parse_format
    end

  private

    attr_reader :embed_code_string

    def parse_field_names
      match = ContentBlockReference::EMBED_REGEX.match(embed_code_string)
      return [] unless match

      all_fields = match[:fields]&.reverse&.chomp("/")&.reverse
      all_fields&.split("/")&.map { |item| convert_field_item(item) }
    end

    def parse_format
      match = FORMAT_REGEX.match(embed_code_string)
      return Format::DEFAULT_FORMAT unless match

      match[:format]
    end

    def convert_field_item(item)
      numeric?(item) ? item.to_i : item.to_sym
    end

    def numeric?(item)
      Float(item, exception: false)
    end
  end
end
