RSpec.describe ContentBlockTools::Presenters::BasePresenter do
  let(:content_id) { SecureRandom.uuid }

  let(:content_block) do
    ContentBlockTools::ContentBlock.new(
      document_type: "something",
      content_id:,
      title: "My content block",
      details: {},
      embed_code: "something",
    )
  end

  it "should render with the title" do
    presenter = described_class.new(content_block)
    expected_html = <<-HTML
      <span
        class="content-embed content-embed__something"
        data-content-block=""
        data-document-type="something"
        data-content-id="#{content_id}"
        data-embed-code="something">My content block</span>
    HTML

    expect(ContentBlockTools.logger).to receive(:info).with("Getting content for content block #{content_id}")

    expect(presenter.render.squish).to eq(expected_html.squish)
  end

  it "should render nested fields" do
    content_block_with_nested_fields = ContentBlockTools::ContentBlock.new(
      document_type: "something",
      content_id:,
      title: "My content block",
      details: {
        first_field: {
          second_field: {
            third_field: "hello world",
          },
        },
      },
      embed_code: "{{embed:content_block_postal_address:#{content_id}/first_field/second_field/third_field}}",
    )

    presenter = described_class.new(content_block_with_nested_fields)
    expected_html = <<-HTML
      <span
        class="content-embed content-embed__something"
        data-content-block=""
        data-document-type="something"
        data-content-id="#{content_id}"
        data-embed-code="{{embed:content_block_postal_address:#{content_id}/first_field/second_field/third_field}}">hello world</span>
    HTML

    expect(presenter.render.squish).to eq(expected_html.squish)
  end

  it "should return the embed code if a given field does not exist" do
    content_block_with_nested_fields = ContentBlockTools::ContentBlock.new(
      document_type: "something",
      content_id:,
      title: "My content block",
      details: {
        first_field: {
          second_field: {
            third_field: "hello world",
          },
        },
      },
      embed_code: "{{embed:content_block_postal_address:#{content_id}/first_field/second_field/fake_field}}",
    )

    presenter = described_class.new(content_block_with_nested_fields)
    expected_html = <<-HTML
      <span
        class="content-embed content-embed__something"
        data-content-block=""
        data-document-type="something"
        data-content-id="#{content_id}"
        data-embed-code="{{embed:content_block_postal_address:#{content_id}/first_field/second_field/fake_field}}">{{embed:content_block_postal_address:#{content_id}/first_field/second_field/fake_field}}</span>
    HTML

    expect(ContentBlockTools.logger).to receive(:warn).with("Content not found for content block #{content_id} and fields [:first_field, :second_field, :fake_field]")

    expect(presenter.render.squish).to eq(expected_html.squish)
  end

  it "should return nested fields if some keys are strings" do
    content_block_with_nested_fields = ContentBlockTools::ContentBlock.new(
      document_type: "something",
      content_id:,
      title: "My content block",
      details: {
        first_field: {
          second_field: {
            "third_field" => "hello world",
          },
        },
      },
      embed_code: "{{embed:content_block_postal_address:#{content_id}/first_field/second_field/third_field}}",
    )

    presenter = described_class.new(content_block_with_nested_fields)
    expected_html = <<-HTML
      <span
        class="content-embed content-embed__something"
        data-content-block=""
        data-document-type="something"
        data-content-id="#{content_id}"
        data-embed-code="{{embed:content_block_postal_address:#{content_id}/first_field/second_field/third_field}}">hello world</span>
    HTML

    expect(presenter.render.squish).to eq(expected_html.squish)
  end
end
