module ContentBlockTools
  module Presenters
    module FieldPresenters
      module TimePeriod
        class StartPresenter < BasePresenter
          def render
            return unless field.present?

            Presenters::FieldPresenters::TimePeriod::DatePresenter.new(
              field,
            ).render
          end
        end
      end
    end
  end
end
