module ContentBlockTools
  module Presenters
    module FieldPresenters
      class BasePresenter
        attr_reader :field

        def initialize(field)
          @field = field
        end

        def render
          field
        end
      end
    end
  end
end
