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
        data-content-id="#{content_id}">My content block</span>
    HTML

    expect(presenter.render.squish).to eq(expected_html.squish)
  end
end
