module ContentBlockTools
  module Presenters
    module BlockPresenters
      module Contact
        class EmailAddressPresenter < ContentBlockTools::Presenters::BlockPresenters::BasePresenter
          def render
            content_tag(:p) do
              concat content_tag(:span, title_content)
              concat content_tag(:a,
                                 item[:email_address],
                                 href: "mailto:#{item[:email_address]}")
            end
          end
        end
      end
    end
  end
end
