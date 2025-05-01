module ContentBlockTools
  module Presenters
    module FieldPresenters
      module Contact
        class EmailAddressPresenter < BasePresenter
          def render
            content_tag(:a, field, class: "govuk-link", href: "mailto:#{field}")
          end
        end
      end
    end
  end
end
