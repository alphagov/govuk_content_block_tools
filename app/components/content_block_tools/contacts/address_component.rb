module ContentBlockTools
  module Contacts
    class AddressComponent < ContentBlockTools::BaseComponent
      include ContentBlockTools::Govspeak

      def initialize(item:)
        @item = item
      end

    private

      attr_reader :item

      def lines
        address_parts.map { |attribute|
          next if item[attribute].blank?

          [attribute, item[attribute]]
        }.compact.to_h
      end

      def address_parts
        %i[recipient street_address town_or_city state_or_county postal_code country]
      end

      def address_line(field, value)
        content_tag(:span, value, { class: class_for_field_name(field) })
      end

      def class_for_field_name(field_name)
        {
          recipient: "organization-name",
          street_address: "street-address",
          town_or_city: "locality",
          state_or_county: "region",
          postal_code: "postal-code",
          country: "country-name",
        }[field_name]
      end
    end
  end
end
