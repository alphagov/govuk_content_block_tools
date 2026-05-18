Given("a tax content block with income tax rates") do
  @content_block_details = {
    tax_type: "Tax",
    things_taxed: {
      income: {
        title: "Income",
        type: "Income",
        rates: [
          {
            name: "Zero rate",
            value: "0%",
            bands: [
              {
                name: "Personal Allowance",
                lower_threshold: { show: true, value: "£0" },
                upper_threshold: { show: true, value: "£12,570" },
              },
            ],
          },
          {
            name: "Basic rate",
            value: "20%",
            bands: [
              {
                name: "Basic rate",
                lower_threshold: { show: true, value: "£12,571" },
                upper_threshold: { show: true, value: "£50,270" },
              },
            ],
          },
          {
            name: "Higher Rate",
            value: "40%",
            bands: [
              {
                name: "Higher rate",
                lower_threshold: { show: true, value: "£50,271" },
                upper_threshold: { show: true, value: "£125,140" },
              },
            ],
          },
          {
            name: "Additional rate",
            value: "45%",
            bands: [
              {
                name: "Additional rate",
                lower_threshold: { show: true, value: "£125,140" },
              },
            ],
          },
        ],
      },
    },
  }
end

Given("a tax content block without income data") do
  @content_block_details = {
    tax_type: "Tax",
    things_taxed: {},
  }
end

When("asked to render tax with embed code {string}") do |embed_code|
  @embed_code = embed_code
  @content_block = ContentBlockTools::ContentBlock.new(
    document_type: "content_block_tax",
    content_id: SecureRandom.uuid,
    title: "Income Tax",
    details: @content_block_details,
    embed_code: @embed_code,
  )

  begin
    @rendered = @content_block.render
    @error = nil
  rescue ContentBlockTools::InvalidFormatError => e
    @error = e
    @rendered = nil
  end
end

Then("the rendered output should be a table with headers:") do |table|
  expect(@error).to be_nil, "Expected no error but got: #{@error&.message}"

  headers = table.raw.first
  headers.each do |header|
    expect(@rendered).to have_tag("th", text: header)
  end
end

Then("the table should have the following rows:") do |table|
  expect(@error).to be_nil, "Expected no error but got: #{@error&.message}"

  table.raw.each do |row|
    row.each do |cell|
      expect(@rendered).to have_tag("td", text: cell)
    end
  end
end
