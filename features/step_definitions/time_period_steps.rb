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
