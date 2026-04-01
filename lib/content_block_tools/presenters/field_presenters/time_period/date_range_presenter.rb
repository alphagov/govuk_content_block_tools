module ContentBlockTools
  module Presenters
    module FieldPresenters
      module TimePeriod
        class TimePeriodPresenterError < RuntimeError; end

        class DateRangePresenter < BasePresenter
          def initialize(field, **args)
            super
            @normalised_date_range = normalise_date_range
          end

          def render
            return unless start_date.present? && end_date.present?

            "#{start_date} to #{end_date}"
          rescue NormalisedDateRange::ParseError => e
            raise TimePeriodPresenterError, "Not a valid date range: #{field} (#{e.message})"
          end

        private

          attr_reader :normalised_date_range

          def start_date
            presented_date(normalised_date_range.start_date)
          end

          def end_date
            presented_date(normalised_date_range.end_date)
          end

          def normalise_date_range
            NormalisedDateRange.new(field)
          end

          def presented_date(date)
            return unless date.present?

            Presenters::FieldPresenters::TimePeriod::DatePresenter.new(
              date,
            ).render
          end
        end
      end
    end
  end
end
