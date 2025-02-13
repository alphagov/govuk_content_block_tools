module ContentBlockTools
  module Presenters
    class PensionPresenter < BasePresenter
    private

      def default_content
        content_block.title
      end
    end
  end
end
