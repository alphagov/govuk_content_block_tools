module ContentBlockTools
  module Presenters
    module BlockPresenters
      module Contact
        class ContactFormPresenter < ContentBlockTools::Presenters::BlockPresenters::BasePresenter
          def render
            content_tag(:p) do
              concat content_tag(:span, title_content)
              concat content_tag(:a,
                                 item[:url],
                                 href: item[:url])
            end
          end
        end
      end
    end
  end
end
