module ContentBlockTools
  # Parses and represents an embed code string
  #
  # An embed code identifies a content block and optionally specifies which
  # fields to render. The format is:
  #   {{embed:block_type:identifier}}
  #   {{embed:block_type:identifier/field1/nested_field2}}
  #
  # @example Basic embed code
  #   embed_code = EmbedCode.new("{{embed:content_block_contact:main-office}}")
  #   embed_code.field_names #=> nil
  #
  # @example Embed code with field path
  #   embed_code = EmbedCode.new("{{embed:content_block_contact:main-office/email_addresses/main}}")
  #   embed_code.field_names #=> [:email_addresses, :main]
  #
  class EmbedCode
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

  private

    attr_reader :embed_code_string

    def parse_field_names
      match = ContentBlockReference::EMBED_REGEX.match(embed_code_string)
      return [] unless match

      all_fields = match[:fields]&.reverse&.chomp("/")&.reverse
      all_fields&.split("/")&.map { |item| convert_field_item(item) }
    end

    def convert_field_item(item)
      numeric?(item) ? item.to_i : item.to_sym
    end

    def numeric?(item)
      Float(item, exception: false)
    end
  end
end
