# frozen_string_literal: true

Given("a TimePeriod content block with the following details:") do |table|
  data = table.rows_hash
  @content_id = SecureRandom.uuid
  @details = {
    "date_range" => {
      "start" => { "date" => data["start_date"], "time" => "00:00" },
      "end" => { "date" => data["end_date"], "time" => "23:59" },
    },
  }
end

When("asked to render a block with {string}") do |embed_code|
  stub_content_store_api

  # Use the main entrypoint - exercises full code pathway
  content_block = ContentBlockTools::ContentBlock.from_embed_code(embed_code)

  begin
    component = ContentBlockTools::TimePeriodComponent.new(content_block: content_block)
    @rendered_output = component.render
  rescue ContentBlockTools::InvalidFormatError => e
    @raised_error = e
  end
end

Then("the rendered output should contain {string}") do |expected_text|
  expect(@rendered_output).to have_tag("p", seen: expected_text)
end

Then("an InvalidFormatError should be raised with message {string}") do |message|
  expect(@raised_error).to be_a(ContentBlockTools::InvalidFormatError)
  expect(@raised_error.message).to eq(message)
end

def stub_content_store_api
  api_response = {
    "content_id" => @content_id,
    "title" => "Tax year",
    "document_type" => "content_block_time_period",
    "details" => @details,
  }

  content_store = double(GdsApi::ContentStore)
  allow(GdsApi).to receive(:content_store).and_return(content_store)
  allow(content_store).to receive(:content_item).and_return(api_response)
end
