RSpec.describe ContentBlockTools::Presenters::BlockPresenters::Contact::EmailAddressPresenter do
  let(:content_block) do
    ContentBlockTools::ContentBlock.new(
      document_type: "something",
      title: "My content block",
      details: {},
      content_id: 123,
      embed_code: "something",
    )
  end

  let(:email_address) do
    {
      "title": "Some email address",
      "email_address": "foo@example.com",
    }
  end

  it "should render successfully" do
    presenter = described_class.new(email_address, content_block:)

    expect(presenter.render).to have_tag("p") do
      with_tag("span", text: "Some email address")
      with_tag("a", text: "foo@example.com", with: { href: "mailto:foo@example.com", class: "email" })
    end
  end

  describe "when rendering in the field_names context" do
    it "should wrap in a contact class with the content block's title" do
      presenter = described_class.new(email_address, rendering_context: :field_names, content_block:)
      result = presenter.render

      expect(result).to have_tag("div", with: { class: "contact" }) do
        with_tag("p", text: content_block.title, with: { class: 'govuk-\!-margin-bottom-3' })
        with_tag("div", with: { class: "email-url-number" })
      end
    end
  end
end
