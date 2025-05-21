module ContentBlockTools
  module Presenters
    module BlockPresenters
      module Contact
        class TelephonePresenter < ContentBlockTools::Presenters::BlockPresenters::BasePresenter
          def render
            content_tag(:p, class: "govuk-body govuk-!-margin-bottom-4") do
              concat content_tag(:span, title_content)
              concat content_tag(:a,
                                 item[:telephone],
                                 class: "govuk-link",
                                 href: "tel:#{CGI.escape item[:telephone]}")
            end
          end
        end
      end
    end
  end
end
