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
      return "" unless tax_table_format? && able_to_format_as_table?

      Tax::TaxTableComponent.new(rates: income_tax_rates).render
    end

  private

    attr_reader :content_block

    delegate :format, :details, to: :content_block

    def validate_format!
      return if SUPPORTED_FORMATS.include?(format)

      raise InvalidFormatError, "Unknown format '#{format}' for tax"
    end

    def able_to_format_as_table?
      income_tax_rates&.present?
    end

    def tax_table_format?
      format == "tax_table"
    end

    def income_tax_rates
      details.dig(:things_taxed, :income, :rates)
    end
  end
end
