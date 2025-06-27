module ContentBlockTools
  module Presenters
    module BlockPresenters
      module Contact
        class TelephonePresenter < ContentBlockTools::Presenters::BlockPresenters::BasePresenter
          BASE_TAG_TYPE = :div

          def render
            [
              number_list,
              (opening_hours_list if item[:opening_hours].any?),
              call_charges_link,
            ].join.html_safe
          end

          def number_list
            content_tag(:ul) do
              item[:telephone_numbers].each do |number|
                concat number_list_item(number)
              end
            end
          end

          def number_list_item(number)
            content_tag(:li, "#{number[:label]}: #{number[:telephone_number]}")
          end

          def opening_hours_list
            content_tag(:ul) do
              item[:opening_hours].each do |item|
                concat opening_hours_list_item(item)
              end
            end
          end

          def opening_hours_list_item(item)
            content_tag(:li, "#{item[:day_from]} to #{item[:day_to]}, #{item[:time_from]} to #{item[:time_to]}")
          end

          def call_charges_link
            if item[:show_uk_call_charges] == "true"
              content_tag(:p) do
                concat content_tag(:a,
                                   "Find out about call charges",
                                   class: "govuk-link",
                                   href: "https://www.gov.uk/call-charges")
              end
            end
          end
        end
      end
    end
  end
end
