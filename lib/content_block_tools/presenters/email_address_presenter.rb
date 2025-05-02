module ContentBlockTools
  module Presenters
    class EmailAddressPresenter < BasePresenter
    private

      def content
        content_tag(:a,
                    content_block.details[:email_address],
                    class: "govuk-link",
                    href: "mailto:#{content_block.details[:email_address]}")
      end
    end
  end
end
