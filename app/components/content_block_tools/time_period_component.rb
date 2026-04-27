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
      format_component.render
    end

  private

    attr_reader :content_block, :normalised_date_range

    delegate :format, to: :content_block

    def format_component
      case defaulted_format
      when "long_form"
        TimePeriod::LongFormComponent.new(start_date:, end_date:)
      when "months_and_years_long"
        TimePeriod::MonthsAndYearsLongComponent.new(start_date:, end_date:)
      when "start_day_and_month"
        TimePeriod::StartDayAndMonthComponent.new(start_date:)
      when "start_month_as_word"
        TimePeriod::StartMonthAsWordComponent.new(start_date:)
      when "years"
        TimePeriod::YearsComponent.new(start_date:, end_date:)
      when "years_short"
        TimePeriod::YearsShortComponent.new(start_date:, end_date:)
      end
    end

    def defaulted_format
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
  end
end
