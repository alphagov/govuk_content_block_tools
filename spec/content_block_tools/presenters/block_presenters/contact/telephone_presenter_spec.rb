RSpec.describe ContentBlockTools::Presenters::BlockPresenters::Contact::TelephonePresenter do
  let(:content_block) do
    ContentBlockTools::ContentBlock.new(
      document_type: "something",
      title: "My content block",
      details: {},
      content_id: 123,
      embed_code: "something",
    )
  end

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
    presenter = described_class.new(phone_number, content_block:)
    result = presenter.render

    expect(result).to_not have_tag("div", with: { class: "contact" })

    expect(result).to have_tag("div", with: { class: "email-url-number" }) do
      with_tag("ul") do
        with_tag("li") do
          with_tag(:span, text: "Office")
          with_tag(:span, text: "1234", with: { class: "tel" })
        end

        with_tag("li") do
          with_tag(:span, text: "International")
          with_tag(:span, text: "5678", with: { class: "tel" })
        end
      end

      with_tag("ul") do
        with_tag("li", text: "Monday to Friday, 9am to 5pm")
      end

      without_tag("a", text: "Find out about call charges", with: { href: "https://www.gov.uk/call-charges" })
      without_text("false")
    end
  end

  describe "when there are no opening hours" do
    let(:opening_hours) { [] }

    it "should render successfully" do
      presenter = described_class.new(phone_number, content_block:)
      result = presenter.render

      expect(result).to have_tag("ul", count: 1)

      expect(result).to have_tag("div", with: { class: "email-url-number" }) do
        with_tag("ul") do
          with_tag("li") do
            with_tag(:span, text: "Office")
            with_tag(:span, text: "1234", with: { class: "tel" })
          end

          with_tag("li") do
            with_tag(:span, text: "International")
            with_tag(:span, text: "5678", with: { class: "tel" })
          end
        end
      end
    end
  end

  describe "when opening hours is nil" do
    let(:opening_hours) { nil }

    it "should render successfully" do
      presenter = described_class.new(phone_number, content_block:)
      result = presenter.render

      expect(result).to have_tag("ul", count: 1)

      expect(result).to have_tag("div", with: { class: "email-url-number" }) do
        with_tag("ul") do
          with_tag("li") do
            with_tag(:span, text: "Office")
            with_tag(:span, text: "1234", with: { class: "tel" })
          end

          with_tag("li") do
            with_tag(:span, text: "International")
            with_tag(:span, text: "5678", with: { class: "tel" })
          end
        end
      end
    end
  end

  describe "when opening hours is nil" do
    let(:opening_hours) { nil }

    it "should render successfully" do
      presenter = described_class.new(phone_number, content_block:)
      result = presenter.render

      expect(result).to have_tag("ul", count: 1)

      expect(result).to have_tag("div", with: { class: "email-url-number" }) do
        with_tag("ul") do
          with_tag("li") do
            with_tag(:span, text: "Office")
            with_tag(:span, text: "1234", with: { class: "tel" })
          end

          with_tag("li") do
            with_tag(:span, text: "International")
            with_tag(:span, text: "5678", with: { class: "tel" })
          end
        end
      end
    end
  end

  describe "when it should show uk call charges" do
    let(:show_uk_call_charges) { "true" }

    it "renders a link" do
      presenter = described_class.new(phone_number, content_block:)

      result = presenter.render

      expect(result).to have_tag("p") do
        with_tag("a", text: "Find out about call charges", with: { href: "https://www.gov.uk/call-charges" })
      end
    end
  end

  describe "when rendering in the field_names context" do
    it "should wrap in a contact class" do
      presenter = described_class.new(phone_number, rendering_context: :field_names, content_block:)
      result = presenter.render

      expect(result).to have_tag("div", with: { class: "contact" }) do
        with_tag("div", with: { class: "email-url-number" })
      end
    end
  end
end
