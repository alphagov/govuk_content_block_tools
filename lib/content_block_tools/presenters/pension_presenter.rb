module ContentBlockTools
  module Presenters
    class PensionPresenter < BasePresenter
    private

      def block_content
        content_block.title
      end
    end
  end
end
