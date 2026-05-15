Feature: Pension amount rendering
  So that users can easily identify and use pension information
  As a content editor
  I want the pension rate to render with a £ prefix

Scenario: Pension amount renders with £ prefix when provided in the data
    Given a pension content block with the following details:
      | field       | value                    |
      | title       | 2026 state pension       |
      | amount      | £436.88                  |
      | frequency   | weekly                   |
      | description | The new pension rate     |
    When I render the content block
    Then the rendered output should be "£436.88"

Scenario: Pension amount renders with £ prefix when not provided in the data
    Given a pension content block with the following details:
      | field       | value                    |
      | title       | 2026 state pension       |
      | amount      | 436.88                   |
      | frequency   | weekly                   |
      | description | The new pension rate     |
    When I render the content block
    Then the rendered output should be "£436.88"
