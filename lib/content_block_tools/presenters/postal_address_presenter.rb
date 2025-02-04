module ContentBlockTools
  module Presenters
    class PostalAddressPresenter < BasePresenter
    private

      def default_content
        "#{content_block.details[:line_1]}, #{content_block.details[:town_or_city]}, #{content_block.details[:postcode]}"
      end
    end
  end
end
