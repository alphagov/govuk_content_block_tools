module ContentBlockTools
  module TimePeriod
    class LongFormComponent < ContentBlockTools::BaseComponent
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

      def formatted_date(date)
        Presenters::FieldPresenters::TimePeriod::DatePresenter.new(date).render
      end
    end
  end
end
