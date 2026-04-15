module ContentBlockTools
  # Parses and represents an embed code string
  #
  # An embed code identifies a content block and optionally specifies which
  # fields to render. The format is:
  #   {{embed:block_type:identifier}}
  #   {{embed:block_type:identifier/field1/nested_field2}}
  #   {{embed:block_type:identifier|format}}
  #   {{embed:block_type:identifier/field1|format}}
  #
  # @example Basic embed code
  #   embed_code = EmbedCode.new("{{embed:content_block_contact:main-office}}")
  #   embed_code.internal_content_path.present? #=> false
  #
  # @example Embed code with field path
  #   embed_code = EmbedCode.new("{{embed:content_block_contact:main-office/email_addresses/main}}")
  #   embed_code.internal_content_path.path #=> [:email_addresses, :main]
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

    # Returns the internal content path for this embed code
    #
    # @return [InternalContentPath] The path to internal content
    def internal_content_path
      @internal_content_path ||= InternalContentPath.new(parse_path_segments)
    end

    # Returns the format specifier from the embed code
    #
    # @return [String] The format name, or Format::DEFAULT_FORMAT if none specified
    def format
      @format ||= parse_format
    end

  private

    attr_reader :embed_code_string

    def parse_path_segments
      match = ContentBlockReference::EMBED_REGEX.match(embed_code_string)
      return [] unless match

      all_segments = strip_leading_slash(match[:internal_content_path])
      return [] if all_segments.nil?

      all_segments.split("/").map { |item| convert_segment(item) }
    end

    def strip_leading_slash(path)
      path&.reverse&.chomp("/")&.reverse
    end

    def convert_segment(item)
      numeric?(item) ? item.to_i : item.to_sym
    end

    def parse_format
      match = FORMAT_REGEX.match(embed_code_string)
      return Format::DEFAULT_FORMAT unless match

      match[:format]
    end

    def numeric?(item)
      Float(item, exception: false)
    end
  end
end
