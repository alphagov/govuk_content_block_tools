module ContentBlockTools
  class PensionComponent < ContentBlockTools::BaseComponent
    SUPPORTED_FORMATS = %w[
      default
      one_off_arrears
    ].freeze

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

      return unless rates.size > 1

      raise InvalidFormatError,
            "Cannot render 'one_off_arrears' format: " \
            "expected exactly one rate, found #{rates.size}"
    end

    def one_off_arrears_format?
      format == "one_off_arrears"
    end
  end
end
