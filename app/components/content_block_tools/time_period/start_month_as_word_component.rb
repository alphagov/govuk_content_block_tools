module ContentBlockTools
  module TimePeriod
    class StartMonthAsWordComponent < ContentBlockTools::BaseComponent
      def initialize(start_date:)
        @start_date = start_date
      end

      def render
        return "" unless start_date

        render_in(view_context)
      end

    private

      attr_reader :start_date

      def formatted_date
        start_date.strftime("%B")
      end
    end
  end
end
