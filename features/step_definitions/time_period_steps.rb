Given("a time period content block with the following date range:") do |table|
  details = table.rows_hash
  @content_block_details = {
    date_range: {
      start: details.fetch("start"),
      end: details.fetch("end"),
    },
  }
end

When("asked to render with embed code {string}") do |embed_code|
  @embed_code = embed_code
  @content_block = ContentBlockTools::ContentBlock.new(
    document_type: "content_block_time_period",
    content_id: SecureRandom.uuid,
    title: "Tax year",
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

Then("the rendered output should be {string}") do |expected_text|
  expect(@error).to be_nil, "Expected no error but got: #{@error&.message}"
  expect(@rendered).to include(expected_text)
end

Then("an InvalidFormatError should be raised with message {string}") do |expected_message|
  expect(@error).to be_a(ContentBlockTools::InvalidFormatError)
  expect(@error.message).to eq(expected_message)
end

Given("a time period content block exists") do
  @content_block = ContentBlockTools::ContentBlock.new(
    document_type: "content_block_time_period",
    content_id: SecureRandom.uuid,
    title: "Current tax year",
    details: {
      date_range: {
        start: "2025-04-06T00:00:00+01:00",
        end: "2026-04-05T23:59:00+01:00",
      },
    },
    embed_code: "{{embed:content_block_time_period:current-tax-year}}",
  )
end

Then("I should see the time period displayed in the default long form") do
  expect(@rendered).to have_tag("div.content-block.content-block--time_period") do
    with_tag("p", seen: "6 April 2025 to 5 April 2026")
  end
end
