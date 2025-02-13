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
    expected_html = <<-HTML
      <span
        class="content-embed content-embed__something"
        data-content-block=""
        data-document-type="something"
        data-content-id="#{content_id}"
        data-embed-code="{{embed:content_block_pension:#{content_id}}}">#{title}</span>
    HTML

    expect(presenter.render.squish).to eq(expected_html.squish)
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
      expected_html = <<-HTML
      <span
        class="content-embed content-embed__something"
        data-content-block=""
        data-document-type="something"
        data-content-id="#{content_id}"
        data-embed-code="{{embed:content_block_pension:#{content_id}/description}}">description of pension</span>
      HTML

      expect(presenter.render.squish).to eq(expected_html.squish)
    end
  end
end
