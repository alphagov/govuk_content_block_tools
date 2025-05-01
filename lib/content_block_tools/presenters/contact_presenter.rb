module ContentBlockTools
  module Presenters
    class ContactPresenter < BasePresenter
      include ActionView::Helpers::TextHelper

      BASE_TAG_TYPE = :div

    private

      def default_content
        content_tag(:div, class: "contact") do
          concat content_tag(:p, content_block.title, class: "govuk-body")
          concat(email_addresses.map { |email_address| email_address_content(email_address) }.join.html_safe) if email_addresses.any?
          concat(phone_numbers.map { |phone_number| phone_number_content(phone_number) }.join.html_safe) if phone_numbers.any?
        end
      end

      def email_address_content(email_address)
        content_tag(:p, class: "govuk-body govuk-!-margin-bottom-4") do
          concat content_tag(:span, email_address[:title])
          concat content_tag(:a,
                             email_address[:email_address],
                             class: "govuk-link",
                             href: "mailto:#{email_address[:email_address]}")
        end
      end

      def phone_number_content(phone_number)
        content_tag(:p, class: "govuk-body govuk-!-margin-bottom-4") do
          concat content_tag(:span, phone_number[:title])
          concat content_tag(:a,
                             phone_number[:telephone],
                             class: "govuk-link",
                             href: "tel:#{CGI.escape phone_number[:telephone]}")
        end
      end

      def email_addresses
        content_block.details[:email_addresses]&.values
      end

      def phone_numbers
        content_block.details[:telephones]&.values
      end
    end
  end
end
