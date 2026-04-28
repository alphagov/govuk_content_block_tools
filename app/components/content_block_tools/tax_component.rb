module ContentBlockTools
  class TaxComponent < ContentBlockTools::BaseComponent
    SUPPORTED_FORMATS = %w[
      default
      tax_table
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

    delegate :format, to: :content_block

    def validate_format!
      return if SUPPORTED_FORMATS.include?(format)

      raise InvalidFormatError, "Unknown format '#{format}' for tax"
    end
  end
end
