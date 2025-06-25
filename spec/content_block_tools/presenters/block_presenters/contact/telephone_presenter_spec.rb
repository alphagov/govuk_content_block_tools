RSpec.describe ContentBlockTools::Presenters::BlockPresenters::Contact::TelephonePresenter do
  let(:phone_number) do
    {
      "title": "Some phone number",
      "telephone_numbers": [
        {
          "label": "Office",
          "telephone_number": "1234",
        },
        {
          "label": "International",
          "telephone_number": "5678",
        },
      ],
      "show_uk_call_charges": "false",
    }
  end

  it "should render successfully" do
    presenter = described_class.new(phone_number)

    expect(presenter.render).to have_tag("div", with: { class: "govuk-body" }) do
      with_tag("ul", with: { class: "govuk-list" }) do
        with_tag("li", text: "Office: 1234")
      end
      without_tag("a", text: "Find out about call charges", with: { href: "https://www.gov.uk/call-charges", class: "govuk-link" })
      without_text("false")
    end
  end

  describe "when it should show uk call charges" do
    let(:phone_number_with_call_charges) do
      {
        "title": "Some phone number",
        "telephone_numbers": [],
        "show_uk_call_charges": "true",
      }
    end

    it "renders a link" do
      presenter = described_class.new(phone_number_with_call_charges)

      expect(presenter.render).to have_tag("div", with: { class: "govuk-body" }) do
        with_tag("p") do
          with_tag("a", text: "Find out about call charges", with: { href: "https://www.gov.uk/call-charges", class: "govuk-link" })
        end
      end
    end
  end
end
