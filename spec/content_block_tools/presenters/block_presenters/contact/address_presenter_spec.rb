RSpec.describe ContentBlockTools::Presenters::BlockPresenters::Contact::AddressPresenter do
  let(:content_block) do
    ContentBlockTools::ContentBlock.new(
      document_type: "something",
      title: "My content block",
      details: {},
      content_id: 123,
      embed_code: "something",
    )
  end

  let(:address) do
    {
      "title": "Some address",
      "street_address": "123 Fake Street",
      "town_or_city": "Springton",
      "state_or_county": "Missouri",
      "postal_code": "TEST 123",
      "country": "USA",
      "description": "Some description",
    }
  end

  it "should render successfully" do
    presenter = described_class.new(address, content_block:)

    expect(presenter).to receive(:render_govspeak)
                           .with(address[:description])
                           .and_call_original

    result = presenter.render

    expect(result).to have_tag(:p) do
      with_tag(:span, text: "Some address")
      with_tag(:span, text: "123 Fake Street", with: { class: "street-address" })
      with_tag(:span, text: "Springton", with: { class: "locality" })
      with_tag(:span, text: "Missouri", with: { class: "region" })
      with_tag(:span, text: "TEST 123", with: { class: "postal-code" })
      with_tag(:span, text: "USA", with: { class: "country-name" })
      with_tag "br", count: 5
    end

    expect(result).to have_tag(:p, text: "Some description")
  end

  it "should render successfully with field_names rendering context with the content block's title" do
    presenter = described_class.new(address, rendering_context: :field_names, content_block:)

    expect(presenter.render).to have_tag(:div, with: { class: "contact" }) do
      with_tag(:p) do
        with_tag(:span, text: "Some address")
        with_tag(:span, text: "123 Fake Street", with: { class: "street-address" })
        with_tag(:span, text: "Springton", with: { class: "locality" })
        with_tag(:span, text: "Missouri", with: { class: "region" })
        with_tag(:span, text: "TEST 123", with: { class: "postal-code" })
        with_tag(:span, text: "USA", with: { class: "country-name" })
        with_tag "br", count: 5
      end
    end
  end

  describe "when some fields are missing" do
    let(:address) do
      {
        "title": "Some address",
        "street_address": "123 Fake Street",
        "town_or_city": "Springton",
        "state_or_county": "",
        "postal_code": "TEST 123",
        "country": "",
      }
    end

    it "should ignore the missing fields" do
      presenter = described_class.new(address, content_block:)

      expect(presenter.render).to have_tag(:p) do
        with_tag(:span, text: "Some address")
        with_tag(:span, text: "123 Fake Street", with: { class: "street-address" })
        with_tag(:span, text: "Springton", with: { class: "locality" })
        with_tag(:span, text: "TEST 123", with: { class: "postal-code" })
        with_tag "br", count: 3
      end
    end
  end
end
