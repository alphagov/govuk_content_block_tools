# frozen_string_literal: true

Feature: Render TimePeriod content block
  So that I present date ranges on GOV.UK pages expected way
  As a publishing platform
  I want time periods blocks to be rendered in the specified format

  Background:
    Given a TimePeriod content block with the following details:
      | start_date | 2025-04-06 |
      | end_date   | 2026-04-05 |

  Scenario: Render with default format when no format specified
    When asked to render a block with "{{embed:content_block_time_period:tax-year}}"
    Then the rendered output should contain "6 April 2025 to 5 April 2026"

  Scenario: Render with explicit default format
    When asked to render a block with "{{embed:content_block_time_period:tax-year|default}}"
    Then the rendered output should contain "6 April 2025 to 5 April 2026"

  Scenario: Render with long_form format
    When asked to render a block with "{{embed:content_block_time_period:tax-year|long_form}}"
    Then the rendered output should contain "April 2025 to April 2026"

  Scenario: Render with start_day_and_month format
    When asked to render a block with "{{embed:content_block_time_period:tax-year|start_day_and_month}}"
    Then the rendered output should contain "6 April"

  Scenario: Render with start_month_as_word format
    When asked to render a block with "{{embed:content_block_time_period:tax-year|start_month_as_word}}"
    Then the rendered output should contain "April"

  Scenario: Render with years format
    When asked to render a block with "{{embed:content_block_time_period:tax-year|years}}"
    Then the rendered output should contain "2025-2026"

  Scenario: Render with years_short format
    When asked to render a block with "{{embed:content_block_time_period:tax-year|years_short}}"
    Then the rendered output should contain "2025-26"

  Scenario: Raise error for invalid format
    When asked to render a block with "{{embed:content_block_time_period:tax-year|unknown_format}}"
    Then an InvalidFormatError should be raised with message "Unknown format 'unknown_format' for time_period"
