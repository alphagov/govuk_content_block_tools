RSpec.describe ContentBlockTools::Presenters::BlockPresenters::Contact::ContactLinkPresenter do
  let(:content_block) do
    ContentBlockTools::ContentBlock.new(
      document_type: "something",
      title: "My content block",
      details: {},
      content_id: 123,
      embed_code: "something",
    )
  end

  let(:contact_link) do
    {
      "title": "Contact form",
      "label": "Contact us",
      "url": "http://example.com",
    }
  end

  it "should render successfully" do
    presenter = described_class.new(contact_link, content_block:)

    expect(presenter.render).to have_tag("p") do
      with_tag("a", text: "Contact us", with: { href: "http://example.com", class: "url" })
    end
  end

  describe "when the label is missing" do
    let(:contact_link) do
      {
        "title": "Contact form",
        "url": "http://example.com",
      }
    end

    it "uses the url as the link text" do
      presenter = described_class.new(contact_link, content_block:)

      expect(presenter.render).to have_tag("p") do
        with_tag("a", text: "http://example.com", with: { href: "http://example.com", class: "url" })
      end
    end
  end

  describe "when rendering in the field_names context" do
    it "should wrap in a contact class with the content block's title" do
      presenter = described_class.new(contact_link, rendering_context: :field_names, content_block:)
      result = presenter.render

      expect(result).to have_tag("div", with: { class: "contact" }) do
        with_tag("p", text: content_block.title, with: { class: 'govuk-\!-margin-bottom-3' })
        with_tag("div", with: { class: "email-url-number" })
      end
    end
  end
end
