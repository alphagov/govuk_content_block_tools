module ContentBlockTools
  module Presenters
    module FieldPresenters
      class BasePresenter
        include ActionView::Context
        include ActionView::Helpers::TagHelper

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
