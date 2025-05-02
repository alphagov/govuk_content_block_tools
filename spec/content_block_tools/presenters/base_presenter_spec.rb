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

  let(:expected_wrapper_attributes) do
    {
      class: "content-embed content-embed__something",
      "data-content-block" => "",
      "data-document-type" => "something",
      "data-content-id" => content_id,
      "data-embed-code" => "something",
    }
  end

  it "should render with the title" do
    presenter = described_class.new(content_block)

    expect(ContentBlockTools.logger).to receive(:info).with("Getting content for content block #{content_id}")

    expect(presenter.render).to have_tag("span", text: "My content block", with: expected_wrapper_attributes)
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

    expect(presenter.render).to have_tag(
      "span",
      text: "hello world",
      with: expected_wrapper_attributes.merge(
        "data-embed-code" => "{{embed:content_block_postal_address:#{content_id}/first_field/second_field/third_field}}",
      ),
    )
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

    expect(ContentBlockTools.logger).to receive(:warn).with("Content not found for content block #{content_id} and fields [:first_field, :second_field, :fake_field]")

    embed_code = "{{embed:content_block_postal_address:#{content_id}/first_field/second_field/fake_field}}"

    expect(presenter.render).to have_tag(
      "span",
      text: embed_code,
      with: expected_wrapper_attributes.merge(
        "data-embed-code" => embed_code,
      ),
    )
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
    embed_code = "{{embed:content_block_postal_address:#{content_id}/first_field/second_field/third_field}}"

    expect(presenter.render).to have_tag(
      "span",
      text: "hello world",
      with: expected_wrapper_attributes.merge(
        "data-embed-code" => embed_code,
      ),
    )
  end

  it "should render fields with the base presenter" do
    presenter_class = ContentBlockTools::Presenters::FieldPresenters::BasePresenter

    render_response = "STUB_RESPONSE"
    presenter_double = double(presenter_class, render: render_response)

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

    expect(presenter_class).to receive(:new).with("hello world") {
      presenter_double
    }

    described_class.new(content_block_with_nested_fields).render

    expect(presenter_double).to have_received(:render)
  end
end
