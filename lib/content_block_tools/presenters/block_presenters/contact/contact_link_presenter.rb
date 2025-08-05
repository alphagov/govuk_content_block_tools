require_relative "./block_level_contact_item"

module ContentBlockTools
  module Presenters
    module BlockPresenters
      module Contact
        class ContactLinkPresenter < ContentBlockTools::Presenters::BlockPresenters::BasePresenter
          include ContentBlockTools::Presenters::BlockPresenters::Contact::BlockLevelContactItem

          def render
            wrapper do
              content_tag(:div, class: "email-url-number") do
                concat link
                concat description if item[:description]
              end
            end
          end

          def link
            content_tag(:p) do
              content_tag(:a,
                          link_text,
                          class: "url",
                          href: item[:url])
            end
          end

          def link_text
            item[:label] || item[:url]
          end

          def description
            render_govspeak(item[:description])
          end
        end
      end
    end
  end
end
