RSpec.describe ContentBlockTools::Presenters::BlockPresenters::Contact::PhoneNumberPresenter do
  let(:phone_number) do
    {
      "title": "Some phone number",
      "telephone": "0891 50 50 50",
    }
  end

  it "should render successfully" do
    presenter = described_class.new(phone_number)

    expect(presenter.render).to have_tag("p", with: { class: "govuk-body" }) do
      with_tag("span", text: "Some phone number: ")
      with_tag("a", text: "0891 50 50 50", with: { href: "tel:0891+50+50+50", class: "govuk-link" })
    end
  end
end
