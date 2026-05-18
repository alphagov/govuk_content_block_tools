Feature: Tax rendering
  So that an editor can easily embed a table of income tax rates and bands
  As a content editor
  I want to embed an income tax table with a single embed code using a format

  Scenario: Render income tax table with tax_table format
    Given a tax content block with income tax rates
    When asked to render tax with embed code "{{embed:content_block_tax:income-tax#tax_table}}"
    Then the rendered output should be a table with headers:
      | Band | Taxable income | Tax rate |
    And the table should have the following rows:
      | Personal Allowance | Up to £12,570       | 0%  |
      | Basic rate         | £12,571 to £50,270  | 20% |
      | Higher rate        | £50,271 to £125,140 | 40% |
      | Additional rate    | over £125,140       | 45% |

  Scenario: Raise error for invalid format
    Given a tax content block with income tax rates
    When asked to render tax with embed code "{{embed:content_block_tax:income-tax#unknown_format}}"
    Then an InvalidFormatError should be raised with message "Unknown format 'unknown_format' for tax"

  Scenario: Raise error when income tax data is missing
    Given a tax content block without income data
    When asked to render tax with embed code "{{embed:content_block_tax:other-tax#tax_table}}"
    Then an InvalidFormatError should be raised with message "Cannot render 'tax_table' format: missing income tax rates"
