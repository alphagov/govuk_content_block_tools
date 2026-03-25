module ContentBlockTools
  class TimePeriodComponent < ContentBlockTools::BaseComponent
    SUPPORTED_FORMATS = %w[
      default
      long_form
      start_day_and_month
      start_month_as_word
      years
      years_short
    ].freeze

    def initialize(content_block:, _block_type: nil, _block_name: nil)
      @content_block = content_block
      validate_format!
    end

    def render
      case format
      when "default"
        render_default
      when "long_form"
        render_long_form
      when "start_day_and_month"
        render_start_day_and_month
      when "start_month_as_word"
        render_start_month_as_word
      when "years"
        render_years
      when "years_short"
        render_years_short
      end
    end

  private

    attr_reader :content_block

    delegate :format, to: :content_block

    def validate_format!
      return if SUPPORTED_FORMATS.include?(format)

      raise InvalidFormatError, "Unknown format '#{format}' for time_period"
    end

    def render_default
      return "" unless start_date && end_date

      content_tag(:p, class: "govuk-body") do
        "#{format_date(start_date, :full)} to #{format_date(end_date, :full)}"
      end
    end

    def render_long_form
      return "" unless start_date && end_date

      content_tag(:p, class: "govuk-body") do
        "#{format_date(start_date, :month_year)} to " \
          "#{format_date(end_date, :month_year)}"
      end
    end

    def render_start_day_and_month
      return "" unless start_date

      content_tag(:p, class: "govuk-body") do
        format_date(start_date, :day_month)
      end
    end

    def render_start_month_as_word
      return "" unless start_date

      content_tag(:p, class: "govuk-body") do
        format_date(start_date, :month_only)
      end
    end

    def render_years
      return "" unless start_date && end_date

      content_tag(:p, class: "govuk-body") do
        "#{start_date.year}-#{end_date.year}"
      end
    end

    def render_years_short
      return "" unless start_date && end_date

      content_tag(:p, class: "govuk-body") do
        "#{start_date.year}-#{end_date.strftime('%y')}"
      end
    end

    def start_date
      @start_date ||= parse_date(:start)
    end

    def end_date
      @end_date ||= parse_date(:end)
    end

    def parse_date(key)
      date_string = content_block.details.dig(:date_range, key, :date)
      return unless date_string

      Date.parse(date_string)
    end

    def format_date(date, style)
      case style
      when :full
        date.strftime("%e %B %Y").strip
      when :month_year
        date.strftime("%B %Y")
      when :day_month
        date.strftime("%e %B").strip
      when :month_only
        date.strftime("%B")
      end
    end
  end
end
