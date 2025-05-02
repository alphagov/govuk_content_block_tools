RSpec.describe ContentBlockTools::Presenters::PensionPresenter do
  let(:content_id) { SecureRandom.uuid }
  let(:details) do
    {
      description: "description of pension",
    }
  end

  let(:title) { "Basic state pension" }

  let(:content_block) do
    ContentBlockTools::ContentBlock.new(
      document_type: "something",
      content_id:,
      title:,
      details:,
      embed_code: "{{embed:content_block_pension:#{content_id}}}",
    )
  end

  it "should render with the title of the pension" do
    presenter = described_class.new(content_block)

    expect(presenter.render).to have_tag("span", text: title, with: {
      class: "content-embed content-embed__something",
      "data-content-block" => "",
      "data-document-type" => "something",
      "data-content-id" => content_id,
      "data-embed-code" => "{{embed:content_block_pension:#{content_id}}}",
    })
  end

  context "when fields have been defined" do
    let(:content_block_with_fields) do
      ContentBlockTools::ContentBlock.new(
        document_type: "something",
        content_id:,
        title: "Pension with fields",
        details:,
        embed_code: "{{embed:content_block_pension:#{content_id}/description}}",
      )
    end

    it "should render only the value of that field" do
      presenter = described_class.new(content_block_with_fields)

      expect(presenter.render).to have_tag("span", text: "description of pension", with: {
        class: "content-embed content-embed__something",
        "data-content-block" => "",
        "data-document-type" => "something",
        "data-content-id" => content_id,
        "data-embed-code" => "{{embed:content_block_pension:#{content_id}/description}}",
      })
    end
  end
end
