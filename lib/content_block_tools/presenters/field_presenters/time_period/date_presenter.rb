module ContentBlockTools
  module Presenters
    module FieldPresenters
      module TimePeriod
        class DatePresenter < BasePresenter
          def render
            return unless field.present?

            time = field.is_a?(String) ? parsed_string : field

            time.strftime("%e %B %Y").strip
          rescue Date::Error
            nil
          end

        private

          def parsed_string
            validate_string_representation

            Time.zone.parse(field)
          end

          def validate_string_representation
            Date.parse(field)
          end
        end
      end
    end
  end
end
