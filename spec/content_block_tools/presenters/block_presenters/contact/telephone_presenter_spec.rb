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

  let(:show_call_charges_info_url) { false }

  let(:call_charges) do
    {
      label: "Some label",
      call_charges_info_url: "http://example.com",
      show_call_charges_info_url:,
    }
  end

  let(:show_bsl_guidance) { false }

  let(:bsl_guidance) do
    {
      show: show_bsl_guidance,
      value: "BSL guidance goes here",
    }
  end

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
  let(:description) { nil }

  let(:phone_number) do
    {
      "title": "Some phone number",
      "description": description,
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
      "call_charges": call_charges,
      "bsl_guidance": bsl_guidance,
    }
  end

  it "should render successfully" do
    presenter = described_class.new(phone_number, content_block:)
    result = presenter.render

    expect(result).to_not have_tag("div", with: { class: "contact" })

    expect(result).to have_tag("div", with: { class: "email-url-number" }) do
      with_tag("div", with: { class: 'govuk-\!-margin-bottom-3' }) do
        with_tag(:p, text: phone_number[:title], with: { class: 'govuk-\!-margin-bottom-0' })
      end

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

      without_tag("a", text: call_charges[:label], with: { href: call_charges[:call_charges_info_url] })
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
    let(:show_call_charges_info_url) { true }

    it "renders a link" do
      presenter = described_class.new(phone_number, content_block:)

      result = presenter.render

      expect(result).to have_tag("p") do
        with_tag("a", text: call_charges[:label], with: { href: call_charges[:call_charges_info_url] })
      end
    end
  end

  describe "when a description is present" do
    let(:description) { "Some description" }

    it "should include the description" do
      presenter = described_class.new(phone_number, content_block:)

      expect(presenter).to receive(:render_govspeak)
                             .with(description, root_class: "govuk-!-margin-top-1 govuk-!-margin-bottom-0")
                             .and_call_original

      result = presenter.render

      expect(result).to_not have_tag("div", with: { class: "contact" })

      expect(result).to have_tag("div", with: { class: "email-url-number" }) do
        with_tag("div", with: { class: 'govuk-\!-margin-bottom-3' }) do
          with_tag(:p, text: phone_number[:title], with: { class: 'govuk-\!-margin-bottom-0' })
          with_tag(:p, text: phone_number[:description], with: { class: 'govuk-\!-margin-top-1 govuk-\!-margin-bottom-0' })
        end
      end
    end
  end

  describe "when BSL guidance should be shown" do
    let(:show_bsl_guidance) { true }

    it "should include the guidance" do
      presenter = described_class.new(phone_number, content_block:)

      expect(presenter).to receive(:render_govspeak)
                             .with(bsl_guidance[:value], root_class: "govuk-!-margin-bottom-0")
                             .and_call_original

      result = presenter.render

      expect(result).to have_tag(:p, text: bsl_guidance[:value], with: { class: 'govuk-\!-margin-bottom-0' })
    end
  end

  describe "when rendering in the field_names context" do
    it "should wrap in a contact class with the content block's title" do
      presenter = described_class.new(phone_number, rendering_context: :field_names, content_block:)
      result = presenter.render

      expect(result).to have_tag("div", with: { class: "contact" }) do
        with_tag("p", text: content_block.title, with: { class: 'govuk-\!-margin-bottom-3' })
        with_tag("div", with: { class: "email-url-number" })
      end
    end
  end
end
