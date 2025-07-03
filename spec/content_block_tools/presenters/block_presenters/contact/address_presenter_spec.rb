RSpec.describe ContentBlockTools::Presenters::BlockPresenters::Contact::AddressPresenter do
  let(:address) do
    {
      "title": "Some address",
      "street_address": "123 Fake Street",
      "locality": "Springton",
      "region": "Missouri",
      "postal_code": "TEST 123",
      "country": "USA",
    }
  end

  it "should render successfully" do
    presenter = described_class.new(address)

    expect(presenter.render).to have_tag(:p) do
      with_tag(:span, text: "123 Fake Street", with: { class: "street-address" })
      with_tag(:span, text: "Springton", with: { class: "locality" })
      with_tag(:span, text: "Missouri", with: { class: "region" })
      with_tag(:span, text: "TEST 123", with: { class: "postal-code" })
      with_tag(:span, text: "USA", with: { class: "country-name" })
      with_tag "br", count: 4
    end
  end

  it "should render successfully with field_names rendering context" do
    presenter = described_class.new(address, rendering_context: :field_names)

    expect(presenter.render).to have_tag(:div, with: { class: "contact" }) do
      with_tag(:p) do
        with_tag(:span, text: "123 Fake Street", with: { class: "street-address" })
        with_tag(:span, text: "Springton", with: { class: "locality" })
        with_tag(:span, text: "Missouri", with: { class: "region" })
        with_tag(:span, text: "TEST 123", with: { class: "postal-code" })
        with_tag(:span, text: "USA", with: { class: "country-name" })
        with_tag "br", count: 4
      end
    end
  end

  describe "when some fields are missing" do
    let(:address) do
      {
        "title": "Some address",
        "street_address": "123 Fake Street",
        "region": "",
        "locality": "Springton",
        "postal_code": "TEST 123",
        "country": "",
      }
    end

    it "should ignore the missing fields" do
      presenter = described_class.new(address)

      expect(presenter.render).to have_tag(:p) do
        with_tag(:span, text: "123 Fake Street", with: { class: "street-address" })
        with_tag(:span, text: "Springton", with: { class: "locality" })
        with_tag(:span, text: "TEST 123", with: { class: "postal-code" })
        with_tag "br", count: 2
      end
    end
  end
end
