require_relative "./block_level_contact_item"

module ContentBlockTools
  module Presenters
    module BlockPresenters
      module Contact
        class AddressPresenter < ContentBlockTools::Presenters::BlockPresenters::BasePresenter
          include ContentBlockTools::Presenters::BlockPresenters::Contact::BlockLevelContactItem

          def render
            wrapper do
              content_tag(:p, class: "adr") do
                %i[title street_address town_or_city state_or_county postal_code country].map { |field|
                  next if item[field].blank?

                  content_tag(:span, item[field], { class: class_for_field_name(field) })
                }.compact_blank.join(",<br/>").html_safe
              end
            end
          end

          def class_for_field_name(field_name)
            {
              street_address: "street-address",
              town_or_city: "locality",
              state_or_county: "region",
              postal_code: "postal-code",
              country: "country-name",
            }[field_name]
          end

        private

          def show_title_in_field_names_context?
            false
          end
        end
      end
    end
  end
end
