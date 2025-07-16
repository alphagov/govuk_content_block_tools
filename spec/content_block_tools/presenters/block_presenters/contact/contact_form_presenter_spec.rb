RSpec.describe ContentBlockTools::Presenters::BlockPresenters::Contact::ContactFormPresenter do
  let(:content_block) do
    ContentBlockTools::ContentBlock.new(
      document_type: "something",
      title: "My content block",
      details: {},
      content_id: 123,
      embed_code: "something",
    )
  end

  let(:contact_form) do
    {
      "title": "Contact us",
      "url": "http://example.com",
    }
  end

  it "should render successfully" do
    presenter = described_class.new(contact_form, content_block:)

    expect(presenter.render).to have_tag("p") do
      with_tag("span", text: "Contact us")
      with_tag("a", text: "http://example.com", with: { href: "http://example.com", class: "url" })
    end
  end

  describe "when rendering in the field_names context" do
    it "should wrap in a contact class" do
      presenter = described_class.new(contact_form, rendering_context: :field_names, content_block:)
      result = presenter.render

      expect(result).to have_tag("div", with: { class: "contact" }) do
        with_tag("div", with: { class: "email-url-number" })
      end
    end
  end
end
