RSpec.describe ContentBlockTools::ContentBlock do
  it "initializes correctly" do
    content_id = SecureRandom.uuid
    title = "Some Title"
    document_type = "content_block_email_address"
    details = { some: "details" }

    content_block = described_class.new(
      document_type:,
      content_id:,
      title:,
      details:,
    )

    expect(content_block.document_type).to eq(document_type)
    expect(content_block.content_id).to eq(content_id)
    expect(content_block.title).to eq(title)
    expect(content_block.details).to eq(details)
  end
end
