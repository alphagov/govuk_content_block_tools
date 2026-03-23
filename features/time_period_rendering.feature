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
