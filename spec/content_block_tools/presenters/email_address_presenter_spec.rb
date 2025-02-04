RSpec.describe ContentBlockTools::Presenters::EmailAddressPresenter do
  let(:content_id) { SecureRandom.uuid }
  let(:email_address) { "foo@example.com" }

  let(:content_block) do
    ContentBlockTools::ContentBlock.new(
      document_type: "something",
      content_id:,
      title: "My content block",
      details: { email_address: },
      embed_code: "something",
    )
  end

  it "should render with the email address" do
    presenter = described_class.new(content_block)
    expected_html = <<-HTML
      <span
        class="content-embed content-embed__something"
        data-content-block=""
        data-document-type="something"
        data-content-id="#{content_id}">#{email_address}</span>
    HTML

    expect(presenter.render.squish).to eq(expected_html.squish)
  end
end
