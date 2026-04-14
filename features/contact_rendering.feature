Feature: Contact rendering
  So that users can easily identify and use contact information
  As a content editor
  I want contact blocks to render in full

  Scenario: Contact renders with default formatting
    Given a contact content block with the following details:
      | field   | value                    |
      | email   | contact@example.gov.uk   |
      | phone   | 020 7946 0958            |
      | address | 10 Downing St, London    |
    When I render the content block
    Then I should see the complete contact details within a vcard