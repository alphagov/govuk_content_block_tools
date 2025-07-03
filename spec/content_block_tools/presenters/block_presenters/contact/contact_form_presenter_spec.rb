RSpec.describe ContentBlockTools::Presenters::BlockPresenters::Contact::ContactFormPresenter do
  let(:contact_form) do
    {
      "title": "Contact us",
      "url": "http://example.com",
    }
  end

  it "should render successfully" do
    presenter = described_class.new(contact_form)

    expect(presenter.render).to have_tag("p") do
      with_tag("span", text: "Contact us")
      with_tag("a", text: "http://example.com", with: { href: "http://example.com", class: "url" })
    end
  end

  describe "when rendering in the field_names context" do
    it "should wrap in a contact class" do
      presenter = described_class.new(contact_form, rendering_context: :field_names)
      result = presenter.render

      expect(result).to have_tag("div", with: { class: "contact" }) do
        with_tag("div", with: { class: "email-url-number" })
      end
    end
  end
end
