Feature: Pension rendering
  So that users can understand pension deferral arrears
  As a content editor
  I want pension blocks to render with arrears calculations

  Scenario: Render one_off_arrears format
    Given a pension content block with weekly rate "£241.30"
    When asked to render pension with embed code "{{embed:content_block_pension:state-pension#one_off_arrears}}"
    Then the rendered output should contain "one-off arrears payment of £12,547.60"
    And the rendered output should contain "one-off arrears payment of £6,515.10"
    And the rendered output should contain a link to "/new-state-pension"

  Scenario: Raise error for unknown format
    Given a pension content block with weekly rate "£241.30"
    When asked to render pension with embed code "{{embed:content_block_pension:state-pension#unknown_format}}"
    Then an InvalidFormatError should be raised with message "Unknown format 'unknown_format' for pension"

  Scenario: Raise error for zero rates
    Given a pension content block with no rates
    When asked to render pension with embed code "{{embed:content_block_pension:state-pension#one_off_arrears}}"
    Then an InvalidFormatError should be raised with message "Cannot render 'one_off_arrears' format: no rates found"

  Scenario: Raise error for multiple rates
    Given a pension content block with multiple rates
    When asked to render pension with embed code "{{embed:content_block_pension:state-pension#one_off_arrears}}"
    Then an InvalidFormatError should be raised with message "Cannot render 'one_off_arrears' format: expected exactly one rate, found 2"
