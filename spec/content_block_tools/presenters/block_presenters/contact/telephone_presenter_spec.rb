RSpec.describe ContentBlockTools::Presenters::BlockPresenters::Contact::TelephonePresenter do
  let(:show_uk_call_charges) { "false" }
  let(:opening_hours) do
    [
      {
        "day_from": "Monday",
        "day_to": "Friday",
        "time_from": "9am",
        "time_to": "5pm",
      },
    ]
  end

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
      "opening_hours": opening_hours,
      "show_uk_call_charges": show_uk_call_charges,
    }
  end

  it "should render successfully" do
    presenter = described_class.new(phone_number)

    expect(presenter.render).to have_tag("div", with: { class: "govuk-body" }) do
      with_tag("ul", with: { class: "govuk-list" }) do
        with_tag("li", text: "Office: 1234")
      end

      with_tag("ul", with: { class: "govuk-list" }) do
        with_tag("li", text: "Monday to Friday, 9am to 5pm")
      end

      without_tag("a", text: "Find out about call charges", with: { href: "https://www.gov.uk/call-charges", class: "govuk-link" })
      without_text("false")
    end
  end

  describe "when there are no opening hours" do
    let(:opening_hours) { [] }

    it "should render successfully" do
      presenter = described_class.new(phone_number)

      expect(presenter.render).to have_tag("div", with: { class: "govuk-body" }) do
        with_tag("ul", with: { class: "govuk-list" }, count: 1)

        with_tag("ul", with: { class: "govuk-list" }) do
          with_tag("li", text: "Office: 1234")
        end
      end
    end
  end

  describe "when it should show uk call charges" do
    let(:show_uk_call_charges) { "true" }

    it "renders a link" do
      presenter = described_class.new(phone_number)

      expect(presenter.render).to have_tag("div", with: { class: "govuk-body" }) do
        with_tag("p") do
          with_tag("a", text: "Find out about call charges", with: { href: "https://www.gov.uk/call-charges", class: "govuk-link" })
        end
      end
    end
  end
end
