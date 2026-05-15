Given("a pension content block with the following details:") do |table|
  details = table.rows_hash.transform_keys(&:to_sym)

  @content_block = ContentBlockTools::ContentBlock.new(
    document_type: "content_block_pension",
    content_id: SecureRandom.uuid,
    title: "Test Pension",
    details: {
      "description" => "The new pension rate",
      "rates" => {
        "full-basic-state-pension" => {
          "title" => details[:title],
          "amount" => details[:amount],
          "frequency" => details[:frequency],
          "description" => details[:description],
        },
      },
    },
    embed_code: "{{embed:content_block_pension:test-pension/rates/full-basic-state-pension/amount}}",
  )
end
