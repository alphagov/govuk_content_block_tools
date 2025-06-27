module ContentBlockTools
  module Presenters
    module BlockPresenters
      class BasePresenter
        include ActionView::Context
        include ActionView::Helpers::TextHelper
        BASE_TAG_TYPE = :span

        attr_reader :item

        def initialize(item)
          @item = item
        end

        def render; end
      end
    end
  end
end
