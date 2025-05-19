module ContentBlockTools
  module Presenters
    class ContactPresenter < BasePresenter
      include ActionView::Helpers::TextHelper

      BASE_TAG_TYPE = :div

      FIELD_PRESENTERS = {
        email_address: ContentBlockTools::Presenters::FieldPresenters::Contact::EmailAddressPresenter,
      }.freeze

      has_embedded_objects :email_addresses, :telephones, :addresses

    private

      def default_content
        content_tag(:div, class: "contact") do
          concat content_tag(:p, content_block.title, class: "govuk-body")
          concat(email_addresses.map { |email_address| ContentBlockTools::Presenters::BlockPresenters::Contact::EmailAddressPresenter.new(email_address).render }.join.html_safe) if email_addresses.any?
          concat(telephones.map { |phone_number| ContentBlockTools::Presenters::BlockPresenters::Contact::PhoneNumberPresenter.new(phone_number).render }.join.html_safe) if telephones.any?
        end
      end
    end
  end
end
