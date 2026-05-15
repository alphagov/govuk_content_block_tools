module ContentBlockTools
  module Presenters
    module FieldPresenters
      module Pension
        class AmountPresenter < BasePresenter
          def render
            field.start_with?("£") ? field : "£#{field}"
          end
        end
      end
    end
  end
end
