When("I render the content block") do
  @rendered = @content_block.render
end

Then("the rendered output should be {string}") do |expected_text|
  expect(@error).to be_nil, "Expected no error but got: #{@error&.message}"
  expect(@rendered).to include(expected_text)
end

Then("I should see the rendering failure message") do
  expect(@rendered).to have_tag(
    "div",
    text: rendering_failure_message(
      title: @content_block.title,
      embed_code: @content_block.embed_code,
    ),
  )
end
