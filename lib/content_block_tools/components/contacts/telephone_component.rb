module ContentBlockTools
  module Components
    module Contacts
      class TelephoneComponent < ContentBlockTools::Components::BaseComponent
        include ContentBlockTools::Govspeak

        def initialize(item:)
          @item = item
        end

      private

        attr_reader :item

        def video_relay_service
          @video_relay_service ||= item[:video_relay_service] || {}
        end

        def show_video_relay_service?
          video_relay_service[:show].present?
        end

        def video_relay_service_content
          "#{video_relay_service[:prefix]} #{video_relay_service[:telephone_number]}"
        end

        def bsl_guidance
          @bsl_guidance ||= item[:bsl_guidance] || {}
        end

        def show_bsl_guidance?
          bsl_guidance[:show].present?
        end

        def opening_hours
          @opening_hours ||= item[:opening_hours] || {}
        end

        def show_opening_hours?
          opening_hours[:show_opening_hours].present?
        end

        def call_charges
          @call_charges ||= item[:call_charges] || {}
        end

        def show_call_charges?
          call_charges[:show_call_charges_info_url].present?
        end
      end
    end
  end
end
