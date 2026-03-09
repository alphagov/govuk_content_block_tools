module ContentBlockTools
  module Presenters
    module FieldPresenters
      module TimePeriod
        class DatePresenter < BasePresenter
          def render
            return unless field.present?

            date = Date.parse(field)
            date.strftime("%e %B %Y").strip
          end
        end
      end
    end
  end
end
