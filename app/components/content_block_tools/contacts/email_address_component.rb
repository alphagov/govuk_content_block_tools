module ContentBlockTools
  module Contacts
    class EmailAddressComponent < ContentBlockTools::BaseComponent
      include ContentBlockTools::Govspeak

      def initialize(item:)
        @item = item
      end

    private

      attr_reader :item

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
    end
  end
end
