module ContentBlockTools
  class PensionComponent < ContentBlockTools::BaseComponent
    SUPPORTED_FORMATS = %w[
      default
      one_off_arrears
    ].freeze

    CURRENCY_REGEX = /\A£?[\d,]+(?:\.\d{1,2})?\z/

    def initialize(content_block:, _block_type: nil, _block_name: nil)
      @content_block = content_block
      validate_format!
      validate_single_rate! if one_off_arrears_format?
    end

    def render
      ""
    end

  private

    attr_reader :content_block

    delegate :format, :details, to: :content_block

    def validate_format!
      return if SUPPORTED_FORMATS.include?(format)

      raise InvalidFormatError, "Unknown format '#{format}' for pension"
    end

    def validate_single_rate!
      rates = details[:rates]

      unless rates.present?
        raise InvalidFormatError,
              "Cannot render 'one_off_arrears' format: no rates found"
      end

      if rates.size > 1
        raise InvalidFormatError,
              "Cannot render 'one_off_arrears' format: " \
              "expected exactly one rate, found #{rates.size}"
      end

      validate_amount!
    end

    def validate_amount!
      amount_string = single_rate[:amount]

      if amount_string.nil? || amount_string.to_s.strip.empty?
        raise InvalidFormatError,
              "Cannot render 'one_off_arrears' format: rate is missing 'amount'"
      end

      unless parseable_currency?(amount_string)
        raise InvalidFormatError,
              "Cannot render 'one_off_arrears' format: " \
              "'#{amount_string}' is not a valid currency amount"
      end

      return unless parse_currency(amount_string) <= 0

      raise InvalidFormatError,
            "Cannot render 'one_off_arrears' format: amount must be positive"
    end

    def single_rate
      details[:rates].values.first
    end

    def parseable_currency?(string)
      CURRENCY_REGEX.match?(string.to_s.strip)
    end

    def parse_currency(string)
      BigDecimal(string.to_s.gsub(/[£,]/, ""))
    end

    def one_off_arrears_format?
      format == "one_off_arrears"
    end
  end
end
