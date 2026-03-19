module ContentBlockTools
  module Format
    MATCHER = Regexp.new(/\|(?<format>\S+)}}$/)
    DEFAULT_FORMAT = "default".freeze

    def self.from_embed_code(embed_code)
      match = MATCHER.match(embed_code)
      return DEFAULT_FORMAT unless match

      match[:format]
    end
  end
end
