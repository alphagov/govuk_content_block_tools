RSpec.describe ContentBlockTools::Contacts::AddressComponent do
  let(:address) do
    {
      "title": "Address",
      "recipient": "Department of something",
      "street_address": "123 Fake Street",
      "town_or_city": "Springton",
      "state_or_county": "Missouri",
      "postal_code": "TEST 123",
      "country": "USA",
      "description": "Some description",
    }
  end

  it "renders an address" do
    result = described_class.new(item: address).render

    expect(result).to have_tag(:p, with: { class: "content-block__body" }) do
      with_tag(:span, text: "Department of something", with: { class: "organization-name" })
      with_tag(:span, text: "123 Fake Street", with: { class: "street-address" })
      with_tag(:span, text: "Springton", with: { class: "locality" })
      with_tag(:span, text: "Missouri", with: { class: "region" })
      with_tag(:span, text: "TEST 123", with: { class: "postal-code" })
      with_tag(:span, text: "USA", with: { class: "country-name" })
      with_tag "br", count: 5
    end

    expect(result).to have_tag(:p, text: "Some description")
  end

  describe "when some fields are missing" do
    let(:address) do
      {
        "street_address": "123 Fake Street",
        "town_or_city": "Springton",
        "state_or_county": "",
        "postal_code": "TEST 123",
        "country": "",
      }
    end

    it "should ignore the missing fields" do
      result = described_class.new(item: address).render

      expect(result).to have_tag(:p, with: { class: "content-block__body" }) do
        with_tag(:span, text: "123 Fake Street", with: { class: "street-address" })
        with_tag(:span, text: "Springton", with: { class: "locality" })
        with_tag(:span, text: "TEST 123", with: { class: "postal-code" })
        with_tag "br", count: 2
      end
    end
  end
end
