require_relative "./block_level_contact_item"

module ContentBlockTools
  module Presenters
    module BlockPresenters
      module Contact
        class ContactFormPresenter < ContentBlockTools::Presenters::BlockPresenters::BasePresenter
          include ContentBlockTools::Presenters::BlockPresenters::Contact::BlockLevelContactItem

          def render
            wrapper do
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
