module ContentBlockTools
  module Pension
    class OneOffArrearsComponent < ContentBlockTools::BaseComponent
      DEFERRAL_PERIODS = [52, 27].freeze
      STATE_PENSION_URL = "/new-state-pension".freeze
      STATE_PENSION_LINK_TEXT = "full new State Pension".freeze

      def initialize(amount:)
        @weekly_amount = amount
      end

      def render
        render_in(view_context)
      end

    private

      attr_reader :weekly_amount

      def paragraphs
        DEFERRAL_PERIODS.map { |weeks| arrears_paragraph(weeks) }
      end

      def arrears_paragraph(weeks)
        arrears = format_currency(weekly_amount * weeks)
        "If you defer your #{state_pension_link} for #{weeks} weeks, " \
        "you'll get a one-off arrears payment of #{arrears}."
      end

      def state_pension_link
        %(<a href="#{STATE_PENSION_URL}">#{STATE_PENSION_LINK_TEXT}</a>)
      end

      def format_currency(amount)
        view_context.number_to_currency(amount, unit: "£", precision: 2)
      end
    end
  end
end
