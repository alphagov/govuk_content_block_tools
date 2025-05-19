module ContentBlockTools
  module Presenters
    module BlockPresenters
      class BasePresenter
        include ActionView::Context
        include ActionView::Helpers::TextHelper

        attr_reader :item

        def initialize(item)
          @item = item
        end

        def title_content
          "#{item[:title]}: "
        end

        def render; end
      end
    end
  end
end
