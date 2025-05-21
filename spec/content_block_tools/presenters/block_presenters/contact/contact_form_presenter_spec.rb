RSpec.describe ContentBlockTools::Presenters::BlockPresenters::Contact::ContactFormPresenter do
  let(:contact_form) do
    {
      "title": "Contact us",
      "url": "http://example.com",
    }
  end

  it "should render successfully" do
    presenter = described_class.new(contact_form)

    expect(presenter.render).to have_tag("p", with: { class: "govuk-body" }) do
      with_tag("span", text: "Contact us: ")
      with_tag("a", text: "http://example.com", with: { href: "http://example.com", class: "govuk-link" })
    end
  end
end
