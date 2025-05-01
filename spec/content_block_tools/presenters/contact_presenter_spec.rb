RSpec.describe ContentBlockTools::Presenters::ContactPresenter do
  let(:content_id) { SecureRandom.uuid }
  let(:email_addresses) { {} }
  let(:telephones) { {} }

  let(:content_block) do
    ContentBlockTools::ContentBlock.new(
      document_type: "contact",
      content_id:,
      title: "My Contact",
      details: { email_addresses: email_addresses, telephones: telephones },
      embed_code: "something",
    )
  end

  let(:expected_wrapper_attributes) do
    {
      class: "content-embed content-embed__contact",
      "data-content-block" => "",
      "data-document-type" => "contact",
      "data-content-id" => content_id,
      "data-embed-code" => "something",
    }
  end

  describe "when no content items are present" do
    it "should render successfully" do
      presenter = described_class.new(content_block)

      expect(presenter.render).to have_tag("div", with: expected_wrapper_attributes) do
        with_tag("div", with: { class: "contact" }) do
          with_tag("p", text: "My Contact", with: { class: "govuk-body" })
        end
      end
    end
  end

  describe "when email addresses are present" do
    let(:email_addresses) do
      {
        "foo": {
          "title": "Some email address",
          "email_address": "foo@example.com",
        },
      }
    end

    it "should render successfully" do
      presenter = described_class.new(content_block)

      expect(presenter.render).to have_tag("div", with: expected_wrapper_attributes) do
        with_tag("div", with: { class: "contact" }) do
          with_tag("p", text: "My Contact", with: { class: "govuk-body" })
          with_tag("p", with: { class: "govuk-body" }) do
            with_tag("span", text: "Some email address")
            with_tag("a", text: "foo@example.com", with: { href: "mailto:foo@example.com", class: "govuk-link" })
          end
        end
      end
    end
  end

  describe "when phone numbers are present" do
    let(:telephones) do
      {
        "foo": {
          "title": "Some phone number",
          "telephone": "0891 50 50 50",
        },
      }
    end

    it "should render successfully" do
      presenter = described_class.new(content_block)

      expect(presenter.render).to have_tag("div", with: expected_wrapper_attributes) do
        with_tag("div", with: { class: "contact" }) do
          with_tag("p", text: "My Contact", with: { class: "govuk-body" })
          with_tag("p", with: { class: "govuk-body" }) do
            with_tag("span", text: "Some phone number")
            with_tag("a", text: "0891 50 50 50", with: { href: "tel:0891+50+50+50", class: "govuk-link" })
          end
        end
      end
    end
  end
end
