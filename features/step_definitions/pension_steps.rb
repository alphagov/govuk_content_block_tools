Given("a pension content block with weekly rate {string}") do |amount|
  @content_block_details = {
    rates: {
      "weekly-rate": {
        title: "Weekly rate",
        amount: amount,
        frequency: "a week",
      },
    },
  }
end

Given("a pension content block with no rates") do
  @content_block_details = {
    rates: {},
  }
end

Given("a pension content block with multiple rates") do
  @content_block_details = {
    rates: {
      "rate-one": {
        title: "Rate one",
        amount: "£100.00",
        frequency: "a week",
      },
      "rate-two": {
        title: "Rate two",
        amount: "£200.00",
        frequency: "a week",
      },
    },
  }
end

When("asked to render pension with embed code {string}") do |embed_code|
  @content_block = ContentBlockTools::ContentBlock.new(
    document_type: "content_block_pension",
    content_id: SecureRandom.uuid,
    title: "State Pension",
    details: @content_block_details,
    embed_code:,
  )

  begin
    @rendered = @content_block.render
    @error = nil
  rescue ContentBlockTools::InvalidFormatError => e
    @error = e
    @rendered = nil
  end
end

Then("the rendered output should contain {string}") do |expected_text|
  expect(@error).to be_nil, "Expected no error but got: #{@error&.message}"
  expect(@rendered).to include(expected_text)
end

Then("the rendered output should contain a link to {string}") do |href|
  expect(@error).to be_nil, "Expected no error but got: #{@error&.message}"
  expect(@rendered).to have_tag("a", with: { href: href })
end
