module ContentBlockTools
  module Presenters
    module BlockPresenters
      module Contact
        class AddressPresenter < ContentBlockTools::Presenters::BlockPresenters::BasePresenter
          def render
            content_tag(:p, class: "govuk-body govuk-!-margin-bottom-4") do
              [
                item[:street_address],
                item[:locality],
                item[:region],
                item[:postal_code],
                item[:country],
              ].compact_blank.join(",<br/>").html_safe
            end
          end
        end
      end
    end
  end
end
