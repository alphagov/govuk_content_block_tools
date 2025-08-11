module ContentBlockTools
  module Components
    module Contacts
      class ContactLinkComponent < ContentBlockTools::Components::BaseComponent
        include ContentBlockTools::Govspeak

        def initialize(item:)
          @item = item
        end

      private

        attr_reader :item

        def link_text
          item[:label] || item[:url]
        end
      end
    end
  end
end
