RSpec.describe ContentBlockTools::Presenters::ContactPresenter do
  let(:content_id) { SecureRandom.uuid }
  let(:email_addresses) { {} }
  let(:telephones) { {} }
  let(:addresses) { {} }
  let(:contact_forms) { {} }

  let(:content_block) do
    ContentBlockTools::ContentBlock.new(
      document_type: "contact",
      content_id:,
      title: "My Contact",
      details: { email_addresses: email_addresses, telephones: telephones, addresses: addresses, contact_forms: contact_forms },
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

    it "should return the email addresses" do
      presenter = described_class.new(content_block)

      expect(presenter.email_addresses).to eq([{
        "title": "Some email address",
        "email_address": "foo@example.com",
      }])
    end

    it "should render successfully" do
      presenter = described_class.new(content_block)

      expect(presenter.render).to have_tag("div", with: expected_wrapper_attributes) do
        with_tag("div", with: { class: "contact" }) do
          with_tag("p", text: "My Contact", with: { class: "govuk-body" })
          with_tag("p", with: { class: "govuk-body" }) do
            with_tag("span", text: "Some email address: ")
            with_tag("a", text: "foo@example.com", with: { href: "mailto:foo@example.com", class: "govuk-link" })
          end
        end
      end
    end

    it "should render an email address when embed code is provided" do
      embed_code = "{{embed:content_block_contact:#{content_id}/email_addresses/foo/email_address}}"

      content_block = ContentBlockTools::ContentBlock.new(
        document_type: "contact",
        content_id:,
        title: "My Contact",
        details: { email_addresses: email_addresses, telephones: telephones },
        embed_code:,
      )

      presenter = described_class.new(content_block)

      expect(presenter.render).to have_tag("span", with: expected_wrapper_attributes.merge({ "data-embed-code" => embed_code })) do
        with_tag(
          :a,
          text: "foo@example.com",
          with: { href: "mailto:foo@example.com", class: "govuk-link" },
        )
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

    it "should return the telephones" do
      presenter = described_class.new(content_block)

      expect(presenter.telephones).to eq([{
        "title": "Some phone number",
        "telephone": "0891 50 50 50",
      }])
    end

    it "should render successfully" do
      presenter = described_class.new(content_block)

      expect(presenter.render).to have_tag("div", with: expected_wrapper_attributes) do
        with_tag("div", with: { class: "contact" }) do
          with_tag("p", text: "My Contact", with: { class: "govuk-body" })
          with_tag("p", with: { class: "govuk-body" }) do
            with_tag("span", text: "Some phone number: ")
            with_tag("a", text: "0891 50 50 50", with: { href: "tel:0891+50+50+50", class: "govuk-link" })
          end
        end
      end
    end
  end

  describe "when addresses are present" do
    let(:addresses) do
      {
        "some_address": {
          "title": "Some address",
          "street_address": "123 Fake Street",
          "locality": "Springton",
          "region": "Missouri",
          "postal_code": "TEST 123",
          "country": "USA",
        },
      }
    end

    it "should return the addresses" do
      presenter = described_class.new(content_block)

      expect(presenter.addresses).to eq([{
        "title": "Some address",
        "street_address": "123 Fake Street",
        "locality": "Springton",
        "region": "Missouri",
        "postal_code": "TEST 123",
        "country": "USA",
      }])
    end

    it "should render successfully" do
      presenter = described_class.new(content_block)

      expect(presenter.render).to have_tag("div", with: expected_wrapper_attributes) do
        with_tag("div", with: { class: "contact" }) do
          with_tag("p", with: { class: "govuk-body" }) do
            with_text "123 Fake Street,Springton,Missouri,TEST 123,USA"
            with_tag "br", count: 4
          end
        end
      end
    end

    it "should render an address when embed code is provided" do
      embed_code = "{{embed:content_block_contact:#{content_id}/addresses/some_address}}"

      content_block = ContentBlockTools::ContentBlock.new(
        document_type: "contact",
        content_id:,
        title: "My Contact",
        details: { addresses: addresses, telephones: telephones },
        embed_code:,
      )

      presenter = described_class.new(content_block)

      expect(presenter.render).to have_tag("span", with: expected_wrapper_attributes.merge({ "data-embed-code" => embed_code, "data-document-type" => "contact" })) do
        with_text "123 Fake Street,Springton,Missouri,TEST 123,USA"
        with_tag "br", count: 4
      end
    end
  end

  describe "when contact forms are present" do
    let(:contact_forms) do
      {
        "foo": {
          "title": "Some contact form",
          "url": "http://example.com",
        },
      }
    end

    it "should return the contact forms" do
      presenter = described_class.new(content_block)

      expect(presenter.contact_forms).to eq([{
        "title": "Some contact form",
        "url": "http://example.com",
      }])
    end

    it "should render successfully" do
      presenter = described_class.new(content_block)

      expect(presenter.render).to have_tag("div", with: expected_wrapper_attributes) do
        with_tag("div", with: { class: "contact" }) do
          with_tag("p", text: "My Contact", with: { class: "govuk-body" })
          with_tag("p", with: { class: "govuk-body" }) do
            with_tag("span", text: "Some contact form: ")
            with_tag("a", text: "http://example.com", with: { href: "http://example.com", class: "govuk-link" })
          end
        end
      end
    end
  end
end
