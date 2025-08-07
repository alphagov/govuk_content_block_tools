require_relative "./block_level_contact_item"

module ContentBlockTools
  module Presenters
    module BlockPresenters
      module Contact
        class TelephonePresenter < ContentBlockTools::Presenters::BlockPresenters::BasePresenter
          include ContentBlockTools::Presenters::BlockPresenters::Contact::BlockLevelContactItem

          def render
            wrapper do
              content_tag(:div) do
                concat description if item[:description].present?
                concat number_list
                concat video_relay_service
                concat bsl_details
                concat opening_hours
                concat call_charges_link
              end
            end
          end

          def description
            render_govspeak(item[:description], root_class: "content-block__body")
          end

          def number_list
            content_tag(:ul, class: "content-block__list") do
              item[:telephone_numbers].each do |number|
                concat number_list_item(number)
              end
            end
          end

          def number_list_item(number)
            content_tag(:li) do
              concat content_tag(:span, "#{number[:label]}: ")
              concat content_tag(:span, number[:telephone_number], { class: "tel" })
            end
          end

          def video_relay_service
            video_relay_service = item[:video_relay_service] || {}

            if video_relay_service[:show]
              content = "#{video_relay_service[:prefix]} #{video_relay_service[:telephone_number]}"
              render_govspeak(content, root_class: "content-block__body")
            end
          end

          def bsl_details
            bsl_guidance = item[:bsl_guidance] || {}

            render_govspeak(bsl_guidance[:value], root_class: "content-block__body") if bsl_guidance[:show]
          end

          def opening_hours
            opening_hours = item[:opening_hours] || {}

            render_govspeak(opening_hours[:opening_hours], root_class: "content-block__body") if opening_hours[:show_opening_hours]
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
                                   class: "content-block__link",
                                   href: call_charges[:call_charges_info_url])
              end
            end
          end
        end
      end
    end
  end
end
