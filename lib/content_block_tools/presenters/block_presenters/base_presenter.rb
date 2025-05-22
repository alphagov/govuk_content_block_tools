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

        def render
          content_tag(:div) do
            item.each_key do |key|
              concat content_tag(:p, item[key])
            end
          end
        end
      end
    end
  end
end
