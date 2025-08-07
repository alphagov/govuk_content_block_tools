require_relative "./block_level_contact_item"

module ContentBlockTools
  module Presenters
    module BlockPresenters
      module Contact
        class EmailAddressPresenter < ContentBlockTools::Presenters::BlockPresenters::BasePresenter
          include ContentBlockTools::Presenters::BlockPresenters::Contact::BlockLevelContactItem

          def render
            wrapper do
              content_tag(:ul, class: "content-block__list") do
                concat email
                concat description if item[:description].present?
              end
            end
          end

          def email
            content_tag(:li) do
              concat content_tag(:a,
                                 link_text,
                                 class: "email content-block__link",
                                 href: "mailto:#{item[:email_address]}#{query_params}")
            end
          end

          def query_params
            params = {
              subject: item[:subject],
              body: item[:body],
            }.compact.map { |k, v| "#{k}=#{v}" }.join("&")

            "?#{params}" if params.present?
          end

          def link_text
            item[:label] || item[:email_address]
          end

          def description
            content_tag(:li) do
              render_govspeak(item[:description])
            end
          end
        end
      end
    end
  end
end
