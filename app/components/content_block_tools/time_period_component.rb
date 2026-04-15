module ContentBlockTools
  class TimePeriodComponent < ContentBlockTools::BaseComponent
    SUPPORTED_FORMATS = %w[
      default
      long_form
      months_and_years_long
      start_day_and_month
      start_month_as_word
      years
      years_short
    ].freeze

    def initialize(content_block:, _block_type: nil, _block_name: nil)
      @content_block = content_block
      @normalised_date_range = normalise_date_range
      validate_format!
    end

    def render
      case format_to_use
      when "long_form"
        render_long_form
      when "months_and_years_long"
        render_months_and_years_long
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

    attr_reader :content_block, :normalised_date_range

    delegate :format, to: :content_block

    def format_to_use
      return "long_form" if format == Format::DEFAULT_FORMAT

      format
    end

    def validate_format!
      return if SUPPORTED_FORMATS.include?(format)

      raise InvalidFormatError, "Unknown format '#{format}' for time_period"
    end

    def normalise_date_range
      NormalisedDateRange.new(content_block.details[:date_range])
    end

    def start_date
      normalised_date_range.start_date
    end

    def end_date
      normalised_date_range.end_date
    end

    def render_long_form
      return "" unless start_date && end_date

      content_tag(:p, class: "govuk-body") do
        "#{format_date(start_date, :full)} to #{format_date(end_date, :full)}"
      end
    end

    def render_months_and_years_long
      return "" unless start_date && end_date

      content_tag(:p, class: "govuk-body") do
        "#{format_date(start_date, :month_year)} to #{format_date(end_date, :month_year)}"
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

    def format_date(date, style)
      case style
      when :full
        Presenters::FieldPresenters::TimePeriod::DatePresenter.new(
          date,
        ).render
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
