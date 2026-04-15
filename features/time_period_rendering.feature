Feature: Time period rendering
  So that users can easily understand date ranges
  As a content editor
  I want time period blocks to render with GDS style formatting

  Background:
    Given a time period content block with the following date range:
      | start | 2025-04-06T00:00:00+01:00 |
      | end   | 2026-04-05T23:59:00+01:00 |

  Scenario: Render with default format when no format specified
    When asked to render with embed code "{{embed:content_block_time_period:tax-year}}"
    Then the rendered output should be "6 April 2025 to 5 April 2026"

  Scenario: Render with explicit default format
    When asked to render with embed code "{{embed:content_block_time_period:tax-year|default}}"
    Then the rendered output should be "6 April 2025 to 5 April 2026"

  Scenario: Render with explicit long_form format
    When asked to render with embed code "{{embed:content_block_time_period:tax-year|long_form}}"
    Then the rendered output should be "6 April 2025 to 5 April 2026"

  Scenario: Render with months_and_years_long format
    When asked to render with embed code "{{embed:content_block_time_period:tax-year|months_and_years_long}}"
    Then the rendered output should be "April 2025 to April 2026"

  Scenario: Render with start_day_and_month format
    When asked to render with embed code "{{embed:content_block_time_period:tax-year|start_day_and_month}}"
    Then the rendered output should be "6 April"

  Scenario: Render with start_month_as_word format
    When asked to render with embed code "{{embed:content_block_time_period:tax-year|start_month_as_word}}"
    Then the rendered output should be "April"

  Scenario: Render with years format
    When asked to render with embed code "{{embed:content_block_time_period:tax-year|years}}"
    Then the rendered output should be "2025-2026"

  Scenario: Render with years_short format
    When asked to render with embed code "{{embed:content_block_time_period:tax-year|years_short}}"
    Then the rendered output should be "2025-26"

  Scenario: Raise error for invalid format
    When asked to render with embed code "{{embed:content_block_time_period:tax-year|unknown_format}}"
    Then an InvalidFormatError should be raised with message "Unknown format 'unknown_format' for time_period"