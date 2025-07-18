require_relative "./block_level_contact_item"

module ContentBlockTools
  module Presenters
    module BlockPresenters
      module Contact
        class EmailAddressPresenter < ContentBlockTools::Presenters::BlockPresenters::BasePresenter
          include ContentBlockTools::Presenters::BlockPresenters::Contact::BlockLevelContactItem

          def render
            wrapper do
              content_tag(:div, class: "email-url-number") do
                concat email
                concat render_govspeak(item[:description]) if item[:description].present?
              end
            end
          end

          def email
            content_tag(:p) do
              concat content_tag(:span, item[:title])
              concat content_tag(:a,
                                 item[:email_address],
                                 class: "email",
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
        end
      end
    end
  end
end
