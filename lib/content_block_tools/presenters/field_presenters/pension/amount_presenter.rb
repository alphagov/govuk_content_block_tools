module ContentBlockTools
  module Presenters
    module FieldPresenters
      module Pension
        class AmountPresenter < BasePresenter
          def render
            "£#{field}"
          end
        end
      end
    end
  end
end
