RSpec.describe ContentBlockTools::Presenters::PostalAddressPresenter do
  let(:content_id) { SecureRandom.uuid }
  let(:postal_address) do
    {
      line_1: "1 street",
      town_or_city: "Somewhereville",
      postcode: "ABC 123",
    }
  end

  let(:postal_html_string) do
    "1 street, Somewhereville, ABC 123"
  end

  let(:content_block) do
    ContentBlockTools::ContentBlock.new(
      document_type: "something",
      content_id:,
      title: "My postal content block",
      details: { **postal_address },
      embed_code: "{{embed:content_block_postal_address:#{content_id}}}",
    )
  end

  it "should render with the postal address" do
    presenter = described_class.new(content_block)
    expected_html = <<-HTML
      <span
        class="content-embed content-embed__something"
        data-content-block=""
        data-document-type="something"
        data-content-id="#{content_id}">#{postal_html_string}</span>
    HTML

    expect(presenter.render.squish).to eq(expected_html.squish)
  end

  context "when fields have been defined" do
    let(:content_block_with_fields) do
      ContentBlockTools::ContentBlock.new(
        document_type: "something",
        content_id:,
        title: "My postal content block",
        details: { **postal_address },
        embed_code: "{{embed:content_block_postal_address:#{content_id}/town_or_city}}",
      )
    end

    let(:content_block_with_fake_fields) do
      ContentBlockTools::ContentBlock.new(
        document_type: "something",
        content_id:,
        title: "My postal content block",
        details: { **postal_address },
        embed_code: "{{embed:content_block_postal_address:#{content_id}/nothing}}",
      )
    end

    it "should render only the value of that field" do
      presenter = described_class.new(content_block_with_fields)
      expected_html = <<-HTML
      <span
        class="content-embed content-embed__something"
        data-content-block=""
        data-document-type="something"
        data-content-id="#{content_id}">Somewhereville</span>
      HTML

      expect(presenter.render.squish).to eq(expected_html.squish)
    end

    it "should return empty string if given a fake field" do
      presenter = described_class.new(content_block_with_fake_fields)
      expected_html = <<-HTML
      <span
        class="content-embed content-embed__something"
        data-content-block=""
        data-document-type="something"
        data-content-id="#{content_id}"></span>
      HTML

      expect(presenter.render.squish).to eq(expected_html.squish)
    end
  end
end
