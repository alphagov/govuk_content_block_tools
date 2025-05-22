module ContentBlockTools
  module Presenters
    class ContactPresenter < BasePresenter
      BASE_TAG_TYPE = :div

    private

      def block_content
        content_tag(:div, class: "contact") do
          super
        end
      end
    end
  end
end
