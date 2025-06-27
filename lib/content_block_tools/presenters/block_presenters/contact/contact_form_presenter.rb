module ContentBlockTools
  module Presenters
    module BlockPresenters
      module Contact
        class ContactFormPresenter < ContentBlockTools::Presenters::BlockPresenters::BasePresenter
          def render
            content_tag(:div, class: "email-url-number") do
              content_tag(:p) do
                concat content_tag(:span, item[:title])
                concat content_tag(:a,
                                   item[:url],
                                   class: "url",
                                   href: item[:url])
              end
            end
          end
        end
      end
    end
  end
end
