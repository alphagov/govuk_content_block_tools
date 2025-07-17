require_relative "./block_level_contact_item"

module ContentBlockTools
  module Presenters
    module BlockPresenters
      module Contact
        class TelephonePresenter < ContentBlockTools::Presenters::BlockPresenters::BasePresenter
          include ContentBlockTools::Presenters::BlockPresenters::Contact::BlockLevelContactItem

          def render
            wrapper do
              content_tag(:div, class: "email-url-number") do
                concat title_and_description
                concat number_list
                concat opening_hours_list if item[:opening_hours].present?
                concat call_charges_link
              end
            end
          end

          def title_and_description
            items = [
              (item_title if item[:title].present?),
              (description if item[:description].present?),
            ].compact

            if items.any?
              content_tag(:div, class: "govuk-!-margin-bottom-3") do
                concat items.join("").html_safe
              end
            end
          end

          def item_title
            content_tag(:p, item[:title], { class: "govuk-!-margin-bottom-0" })
          end

          def description
            render_govspeak(item[:description], root_class: "govuk-!-margin-top-1 govuk-!-margin-bottom-0")
          end

          def number_list
            content_tag(:ul) do
              item[:telephone_numbers].each do |number|
                concat number_list_item(number)
              end
            end
          end

          def number_list_item(number)
            content_tag(:li) do
              concat content_tag(:span, number[:label])
              concat content_tag(:span, number[:telephone_number], { class: "tel" })
            end
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
            call_charges = item[:call_charges] || {}

            if call_charges[:show_call_charges_info_url]
              content_tag(:p) do
                concat content_tag(:a,
                                   call_charges[:label],
                                   class: "govuk-link",
                                   href: call_charges[:call_charges_info_url])
              end
            end
          end
        end
      end
    end
  end
end
