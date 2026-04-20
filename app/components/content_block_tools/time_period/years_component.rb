module ContentBlockTools
  module TimePeriod
    class YearsComponent < ContentBlockTools::BaseComponent
      def initialize(start_date:, end_date:)
        @start_date = start_date
        @end_date = end_date
      end

      def render
        return "" unless start_date && end_date

        render_in(view_context)
      end

    private

      attr_reader :start_date, :end_date

      def formatted_years
        "#{start_date.year}-#{end_date.year}"
      end
    end
  end
end
