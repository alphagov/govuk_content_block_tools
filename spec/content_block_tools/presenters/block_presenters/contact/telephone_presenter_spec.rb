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
    }
  end

  it "should render successfully" do
    presenter = described_class.new(phone_number)

    expect(presenter.render).to have_tag("div", with: { class: "govuk-body" }) do
      with_tag("ul", with: { style: "list-style: none;" }) do
        with_tag("li") do
          with_tag("span", text: "Office: ")
          with_tag("a", text: "1234", with: { href: "tel:1234", class: "govuk-link" })
        end
      end
    end
  end
end
