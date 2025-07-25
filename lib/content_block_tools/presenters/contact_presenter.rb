module ContentBlockTools
  module Presenters
    class ContactPresenter < BasePresenter
      include ActionView::Helpers::TextHelper
      include ContentBlockTools::Govspeak

      BASE_TAG_TYPE = :div

      FIELD_PRESENTERS = {
        email_address: ContentBlockTools::Presenters::FieldPresenters::Contact::EmailAddressPresenter,
      }.freeze

      BLOCK_PRESENTERS = {
        addresses: ContentBlockTools::Presenters::BlockPresenters::Contact::AddressPresenter,
        telephones: ContentBlockTools::Presenters::BlockPresenters::Contact::TelephonePresenter,
        email_addresses: ContentBlockTools::Presenters::BlockPresenters::Contact::EmailAddressPresenter,
        contact_forms: ContentBlockTools::Presenters::BlockPresenters::Contact::ContactFormPresenter,
      }.freeze

      has_embedded_objects :addresses, :email_addresses, :telephones, :contact_forms

    private

      def default_content
        content_tag(:div, class: "contact") do
          content_tag(:div, class: "content") do
            content_tag(:div, class: "vcard contact-inner") do
              concat content_tag(:p, content_block.title, class: "fn org")
              concat render_govspeak(content_block.details[:description]) if content_block.details[:description]
              embedded_objects.each do |object|
                items = send(object)
                concat(items.map { |item| presenter_for_object_type(object).new(item, content_block:).render }.join.html_safe)
              end
            end
          end
        end
      end

      def presenter_for_object_type(type)
        "ContentBlockTools::Presenters::BlockPresenters::Contact::#{type.to_s.singularize.underscore.camelize}Presenter".constantize
      end
    end
  end
end
