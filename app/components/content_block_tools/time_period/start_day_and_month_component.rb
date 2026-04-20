module ContentBlockTools
  module TimePeriod
    class StartDayAndMonthComponent < ContentBlockTools::BaseComponent
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
        start_date.strftime("%e %B").strip
      end
    end
  end
end
