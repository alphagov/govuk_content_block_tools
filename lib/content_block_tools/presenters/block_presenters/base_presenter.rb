module ContentBlockTools
  module Presenters
    module BlockPresenters
      class BasePresenter
        include ActionView::Context
        include ActionView::Helpers::TextHelper
        include ContentBlockTools::Govspeak

        BASE_TAG_TYPE = :span

        attr_reader :item

        def initialize(item, **_args)
          @item = item
        end

        def render; end
      end
    end
  end
end
