Given("a contact content block with the following details:") do |table|
  details = table.rows_hash.transform_keys(&:to_sym)

  @content_block = ContentBlockTools::ContentBlock.new(
    document_type: "content_block_contact",
    content_id: SecureRandom.uuid,
    title: "Test Contact",
    details: {
      email_addresses: {
        main: {
          title: "Email",
          email_address: details[:email],
        },
      },
      telephones: {
        main: {
          title: "Phone",
          telephone_numbers: [
            { label: "Telephone", telephone_number: details[:phone] },
          ],
        },
      },
      addresses: {
        main: {
          title: "Address",
          street_address: details[:address],
        },
      },
      order: %w[email_addresses.main telephones.main addresses.main],
    },
    embed_code: "{{embed:content_block_contact:test-contact}}",
  )
end

Then("I should see the complete contact details within a vcard") do
  expect(@rendered).to have_tag("div.content-block.content-block--contact") do
    with_tag("div.vcard") do
      with_tag "div", with: { "data-diff-key" => "email_addresses-main" } do
        with_tag("dt", seen: "Email")
        with_tag(
          "a",
          with: { href: "mailto:contact@example.gov.uk" },
          seen: "contact@example.gov.uk",
        )
      end

      with_tag "div", with: { "data-diff-key" => "telephones-main" } do
        with_tag("dt", seen: "Phone")
        with_tag("dd", seen: "Telephone: 020 7946 0958")
      end

      with_tag "div", with: { "data-diff-key" => "addresses-main" } do
        with_tag("dt", seen: "Address")
        with_tag("dd", seen: "10 Downing St, London")
      end
    end
  end
end
