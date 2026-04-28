module ContentBlockTools
  module Tax
    class TaxTableComponent < ContentBlockTools::BaseComponent
      def initialize(rates:)
        @rates = rates
      end

      def render
        render_in(view_context)
      end

    private

      attr_reader :rates

      def table_head
        [
          { text: "Band" },
          { text: "Taxable income" },
          { text: "Tax rate" },
        ]
      end

      def table_rows
        rates.each_with_index.map do |rate, index|
          [
            { text: band_name(rate) },
            { text: taxable_income_text(rate, index) },
            { text: rate_value(rate) },
          ]
        end
      end

      def band_name(rate)
        rate.dig(:bands, 0, :name)
      end

      def rate_value(rate)
        rate[:value]
      end

      def taxable_income_text(rate, index)
        if only_one_rate? || last_row?(index)
          "over #{lower_threshold(rate)}"
        elsif first_row?(index)
          "Up to #{upper_threshold(rate)}"
        else
          "#{lower_threshold(rate)} to #{upper_threshold(rate)}"
        end
      end

      def only_one_rate?
        rates.length == 1
      end

      def first_row?(index)
        index.zero?
      end

      def last_row?(index)
        index == rates.length - 1
      end

      def lower_threshold(rate)
        rate.dig(:bands, 0, :lower_threshold, :value)
      end

      def upper_threshold(rate)
        rate.dig(:bands, 0, :upper_threshold, :value)
      end
    end
  end
end
