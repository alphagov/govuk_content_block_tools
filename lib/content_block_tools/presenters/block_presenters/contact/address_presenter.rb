module ContentBlockTools
  module Presenters
    module BlockPresenters
      module Contact
        class AddressPresenter < ContentBlockTools::Presenters::BlockPresenters::BasePresenter
          def render
            content_tag(:p, class: "adr") do
              %i[street_address locality region postal_code country].map { |field|
                next if item[field].blank?

                content_tag(:span, item[field], { class: class_for_field_name(field) })
              }.compact_blank.join(",<br/>").html_safe
            end
          end

          def class_for_field_name(field_name)
            {
              street_address: "street-address",
              locality: "locality",
              region: "region",
              postal_code: "postal-code",
              country: "country-name",
            }[field_name]
          end
        end
      end
    end
  end
end
