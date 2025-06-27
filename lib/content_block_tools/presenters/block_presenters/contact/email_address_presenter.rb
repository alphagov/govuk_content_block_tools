module ContentBlockTools
  module Presenters
    module BlockPresenters
      module Contact
        class EmailAddressPresenter < ContentBlockTools::Presenters::BlockPresenters::BasePresenter
          def render
            content_tag(:div, class: "email-url-number") do
              content_tag(:p) do
                concat content_tag(:span, item[:title])
                concat content_tag(:a,
                                   item[:email_address],
                                   class: "email",
                                   href: "mailto:#{item[:email_address]}")
              end
            end
          end
        end
      end
    end
  end
end
