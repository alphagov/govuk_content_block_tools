# frozen_string_literal: true

module ContentBlockTools
  class NormalisedDateRange
    class ParseError < StandardError; end

    def initialize(date_range)
      @date_range = date_range || {}
    end

    def start_time
      @start_time ||= parse_value(date_range[:start])
    end

    def end_time
      @end_time ||= parse_value(date_range[:end])
    end

    def start_date
      start_time&.to_date
    end

    def end_date
      end_time&.to_date
    end

  private

    attr_reader :date_range

    def parse_value(value)
      return nil if value.blank?

      if value.is_a?(Hash)
        parse_legacy_format(value)
      else
        parse_iso8601_format(value)
      end
    end

    def parse_legacy_format(value)
      date_string = value[:date]
      time_string = value[:time]

      return nil if date_string.blank?

      # Validate date with Date.parse (stricter than Time.zone.parse)
      Date.parse(date_string)

      datetime_string = [date_string, time_string].compact.join(" ")
      Time.zone.parse(datetime_string)
    rescue Date::Error
      raise ParseError, "Invalid legacy date format: #{value.inspect}"
    end

    def parse_iso8601_format(datetime_string)
      Time.parse(datetime_string)
    rescue ArgumentError
      raise ParseError, "Invalid ISO 8601 format: #{datetime_string.inspect}"
    end
  end
end
