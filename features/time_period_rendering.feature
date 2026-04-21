Feature: Time period rendering
  So that users can easily understand date ranges
  As a content editor
  I want time period blocks to render with GDS style formatting

  Scenario: Time period renders with default formatting
    Given a time period content block exists
    When I render the content block
    Then I should see the time period displayed in the default long form