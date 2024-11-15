RSpec.describe ContentBlockTools::ContentBlockReference do
  it "initializes correctly" do
    content_id = SecureRandom.uuid
    document_type = "content_block_email_address"
    embed_code = "{{embed:content_block_email_address:#{SecureRandom.uuid}}}"

    content_block = described_class.new(
      document_type:,
      content_id:,
      embed_code:,
    )

    expect(content_block.document_type).to eq(document_type)
    expect(content_block.content_id).to eq(content_id)
    expect(content_block.embed_code).to eq(embed_code)
  end
end
