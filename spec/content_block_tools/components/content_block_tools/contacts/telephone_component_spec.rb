RSpec.describe ContentBlockTools::Contacts::TelephoneComponent do
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

  let(:show_video_relay_service) { false }

  let(:video_relay_service) do
    {
      show: show_video_relay_service,
      label: "Some label",
      telephone_number: "0800 1234 1122",
      source: "Provider link",
    }
  end

  let(:show_opening_hours) { false }

  let(:opening_hours) do
    {
      show_opening_hours: show_opening_hours,
      opening_hours: "Monday to Friday, 9am to 5pm",
    }
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
      "video_relay_service": video_relay_service,
    }
  end

  it "should render successfully" do
    result = described_class.new(item: phone_number).render

    expect(result).to_not have_tag("div", with: { class: "contact" })

    expect(result).to have_tag("ul", with: { class: "content-block__list" }) do
      with_tag("li") do
        with_tag(:span, text: "Office: ")
        with_tag(:span, text: "1234", with: { class: "tel" })
      end

      with_tag("li") do
        with_tag(:span, text: "International: ")
        with_tag(:span, text: "5678", with: { class: "tel" })
      end
    end
  end

  describe "when show_video_relay_service is true" do
    let(:show_video_relay_service) { true }

    it "should show relay details" do
      component = described_class.new(item: phone_number)

      video_relay_service_content =
        "#{video_relay_service[:label]} " \
          "#{video_relay_service[:telephone_number]} " \
          "#{video_relay_service[:source]}"

      expect(component).to receive(:render_govspeak)
                             .with(video_relay_service_content)
                             .and_call_original

      expect(component.render).to have_tag("p", text: video_relay_service_content)
    end
  end

  describe "when there are no opening hours" do
    let(:opening_hours) { {} }

    it "should render successfully" do
      result = described_class.new(item: phone_number).render

      expect(result).to have_tag("ul", count: 1)

      expect(result).to have_tag("ul", with: { class: "content-block__list" }) do
        with_tag("li") do
          with_tag(:span, text: "Office: ")
          with_tag(:span, text: "1234", with: { class: "tel" })
        end

        with_tag("li") do
          with_tag(:span, text: "International: ")
          with_tag(:span, text: "5678", with: { class: "tel" })
        end
      end
    end
  end

  describe "when opening hours is nil" do
    let(:opening_hours) { nil }

    it "should render successfully" do
      result = described_class.new(item: phone_number).render

      expect(result).to have_tag("ul", count: 1)

      expect(result).to have_tag("ul", with: { class: "content-block__list" }) do
        with_tag("li") do
          with_tag(:span, text: "Office: ")
          with_tag(:span, text: "1234", with: { class: "tel" })
        end

        with_tag("li") do
          with_tag(:span, text: "International: ")
          with_tag(:span, text: "5678", with: { class: "tel" })
        end
      end
    end
  end

  describe "when it should show opening hours" do
    let(:show_opening_hours) { true }

    it "should render successfully" do
      component = described_class.new(item: phone_number)

      expect(component).to receive(:render_govspeak)
                             .with(opening_hours[:opening_hours])
                             .and_call_original

      result = component.render

      expect(result).to have_tag("p", text: opening_hours[:opening_hours])
    end
  end

  describe "when it should show uk call charges" do
    let(:show_call_charges_info_url) { true }

    it "renders a link" do
      component = described_class.new(item: phone_number)

      result = component.render

      expect(result).to have_tag("p") do
        with_tag("a", text: /#{call_charges[:label]}/, with: { href: call_charges[:call_charges_info_url] })
      end
    end
  end

  describe "when a description is present" do
    let(:description) { "Some description" }

    it "should include the description" do
      component = described_class.new(item: phone_number)

      expect(component).to receive(:render_govspeak)
                             .with(description)
                             .and_call_original

      result = component.render

      expect(result).to_not have_tag("div", with: { class: "contact" })

      expect(result).to have_tag(:p, text: /#{phone_number[:description]}/)
    end
  end

  describe "when BSL guidance should be shown" do
    let(:show_bsl_guidance) { true }

    it "should include the guidance" do
      component = described_class.new(item: phone_number)

      expect(component).to receive(:render_govspeak)
                             .with(bsl_guidance[:value])
                             .and_call_original

      result = component.render

      expect(result).to have_tag(:p, text: /#{bsl_guidance[:value]}/)
    end
  end
end
