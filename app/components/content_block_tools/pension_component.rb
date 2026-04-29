module ContentBlockTools
  class PensionComponent < ContentBlockTools::BaseComponent
    SUPPORTED_FORMATS = %w[
      default
      one_off_arrears
    ].freeze

    def initialize(content_block:, _block_type: nil, _block_name: nil)
      @content_block = content_block
      validate_format!
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
  end
end
