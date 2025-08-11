RSpec.describe ContentBlockTools::Components::Contacts::ContactLinkComponent do
  let(:contact_link) do
    {
      "title": "Contact form",
      "label": "Contact us",
      "url": "http://example.com",
    }
  end

  it "should render successfully" do
    result = described_class.new(item: contact_link).render

    expect(result).to have_tag("ul", with: { class: "content-block__list" }) do
      with_tag("li") do
        with_tag("a", text: /Contact us/, with: { href: "http://example.com", class: "url content-block__link" })
      end
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
      result = described_class.new(item: contact_link).render

      expect(result).to have_tag("ul", with: { class: "content-block__list" }) do
        with_tag("li") do
          with_tag("a", text: /http:\/\/example.com/, with: { href: "http://example.com", class: "url content-block__link" })
        end
      end
    end
  end

  describe "when description is present" do
    let(:contact_link) do
      {
        "title": "Contact form",
        "label": "Contact us",
        "url": "http://example.com",
        "description": "Some description",
      }
    end

    it "should render successfully" do
      component = described_class.new(item: contact_link)

      expect(component).to receive(:render_govspeak)
                             .with(contact_link[:description])
                             .and_call_original

      expect(component.render).to have_tag("ul", with: { class: "content-block__list" }) do
        with_tag("li", text: contact_link[:description])
      end
    end
  end
end
