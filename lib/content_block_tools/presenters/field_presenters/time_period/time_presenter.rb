module ContentBlockTools
  module Presenters
    module FieldPresenters
      module TimePeriod
        class TimePresenter < BasePresenter
          def render
            time = Time.parse(field)
            hour = time.strftime("%H")
            minute = time.strftime("%M")

            if minute == "00"
              return "midday" if hour == "12"
              return "midnight" if hour == "00"

              return time.strftime("%l%P").strip
            end

            time.strftime("%l:%M%P").strip
          end
        end
      end
    end
  end
end
