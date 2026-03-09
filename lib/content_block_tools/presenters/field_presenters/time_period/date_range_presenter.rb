module ContentBlockTools
  module Presenters
    module FieldPresenters
      module TimePeriod
        class TimePeriodPresenterError < RuntimeError; end

        class DateRangePresenter < BasePresenter
          def render
            return unless start_date.present? && end_date.present?

            "#{start_date} to #{end_date}"
          rescue Date::Error, TypeError
            raise TimePeriodPresenterError, "Not a valid date range: #{field}"
          end

        private

          def start_date
            presented_date(field.dig(:start, :date))
          end

          def end_date
            presented_date(field.dig(:end, :date))
          end

          def presented_date(date)
            Presenters::FieldPresenters::TimePeriod::DatePresenter.new(
              date,
            ).render
          end
        end
      end
    end
  end
end
