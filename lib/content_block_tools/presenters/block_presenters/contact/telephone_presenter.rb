module ContentBlockTools
  module Presenters
    module BlockPresenters
      module Contact
        class TelephonePresenter < ContentBlockTools::Presenters::BlockPresenters::BasePresenter
          def render
            content_tag(:div, class: "govuk-body govuk-!-margin-bottom-4") do
              concat number_list
            end
          end

          def number_list
            content_tag(:ul, class: "govuk-!-padding-0", style: "list-style: none;") do
              item[:telephone_numbers].each do |number|
                concat number_list_item(number)
              end
            end
          end

          def number_list_item(number)
            content_tag(:li) do
              concat content_tag(:span, "#{number[:label]}: ")
              concat content_tag(:a,
                                 number[:telephone_number],
                                 class: "govuk-link",
                                 href: "tel:#{CGI.escape number[:telephone_number]}")
            end
          end
        end
      end
    end
  end
end
