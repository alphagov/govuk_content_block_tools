RSpec.describe ContentBlockTools::Presenters::ContactPresenter do
  let(:content_id) { SecureRandom.uuid }
  let(:email_addresses) { {} }
  let(:telephones) { {} }
  let(:addresses) { {} }
  let(:contact_links) { {} }
  let(:description) { nil }

  let(:content_block) do
    ContentBlockTools::ContentBlock.new(
      document_type: "contact",
      content_id:,
      title: "My Contact",
      details: { email_addresses: email_addresses, telephones: telephones, addresses: addresses, contact_links: contact_links, description: },
      embed_code: "something",
    )
  end

  let(:expected_wrapper_attributes) do
    {
      class: "content-block content-block--contact",
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
          with_tag("div", with: { class: "content" }) do
            with_tag("div", with: { class: "vcard contact-inner" }) do
              with_tag("p", text: "My Contact", with: { class: "fn org" })
            end
          end
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
          with_tag("div", with: { class: "content" }) do
            with_tag("div", with: { class: "vcard contact-inner" }) do
              with_tag("p", text: "My Contact")
              with_tag("p") do
                with_tag("a", text: "foo@example.com", with: { href: "mailto:foo@example.com" })
              end
            end
          end
        end
      end
    end

    it "should render an email address block when embed code is provided" do
      embed_code = "{{embed:content_block_contact:#{content_id}/email_addresses/foo}}"

      content_block = ContentBlockTools::ContentBlock.new(
        document_type: "contact",
        content_id:,
        title: "My Contact",
        details: { email_addresses: email_addresses, telephones: telephones },
        embed_code:,
      )

      presenter = described_class.new(content_block)

      expect(presenter.render).to have_tag("div", with: expected_wrapper_attributes.merge({ "data-embed-code" => embed_code })) do
        with_tag("div", with: { class: "contact" }) do
          with_tag("div", with: { class: "email-url-number" }) do
            with_tag("p") do
              with_tag("a", text: "foo@example.com", with: { href: "mailto:foo@example.com" })
            end
          end
        end
      end
    end

    it "should render an individual email address when embed code is provided" do
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
          with: { href: "mailto:foo@example.com" },
        )
      end
    end
  end

  describe "when phone numbers are present" do
    let(:telephones) do
      {
        "foo": {
          "title": "Some phone number",
          "telephone_numbers": [
            {
              label: "Telephone",
              telephone_number: "0891 50 50 50",
            },
          ],
          "opening_hours": {
            "show_opening_hours": true,
            "opening_hours": "Monday to Friday, 9am to 5pm",
          },
        },
      }
    end

    it "should return the telephones" do
      presenter = described_class.new(content_block)

      expect(presenter.telephones).to eq([{
        "title": "Some phone number",
        "telephone_numbers": [
          {
            label: "Telephone",
            telephone_number: "0891 50 50 50",
          },
        ],
        "opening_hours": {
          "show_opening_hours": true,
          "opening_hours": "Monday to Friday, 9am to 5pm",
        },
      }])
    end

    it "should render successfully" do
      presenter = described_class.new(content_block)

      expect(presenter.render).to have_tag("div", with: expected_wrapper_attributes) do
        with_tag("div", with: { class: "contact" }) do
          with_tag("div", with: { class: "content" }) do
            with_tag("div", with: { class: "vcard contact-inner" }) do
              with_tag("p", text: "My Contact")
              with_tag("ul") do
                with_tag("li") do
                  with_tag("span", text: "Telephone")
                  with_tag("span", text: "0891 50 50 50", with: { class: "tel" })
                end
              end

              with_tag("p", text: "Monday to Friday, 9am to 5pm")
            end
          end
        end
      end
    end

    it "should render a telephone number when embed code is provided" do
      embed_code = "{{embed:content_block_contact:#{content_id}/telephones/foo}}"

      content_block = ContentBlockTools::ContentBlock.new(
        document_type: "contact",
        content_id:,
        title: "My Contact",
        details: { addresses: addresses, telephones: telephones },
        embed_code:,
      )

      presenter = described_class.new(content_block)

      expect(presenter.render).to have_tag("div", with: expected_wrapper_attributes.merge({ "data-embed-code" => embed_code, "data-document-type" => "contact" })) do
        with_tag("div", with: { class: "contact" }) do
          with_tag("div", with: { class: "email-url-number" }) do
            with_tag("ul") do
              with_tag("li") do
                with_tag("span", text: "Telephone")
                with_tag("span", text: "0891 50 50 50", with: { class: "tel" })
              end
            end
          end
        end
      end
    end

    it "should render an individual telephone number when a reference to the number is provided" do
      embed_code = "{{embed:content_block_contact:#{content_id}/telephones/foo/telephone_numbers/0/telephone_number}}"

      content_block = ContentBlockTools::ContentBlock.new(
        document_type: "contact",
        content_id:,
        title: "My Contact",
        details: { addresses: addresses, telephones: telephones },
        embed_code:,
      )

      presenter = described_class.new(content_block)

      expect(presenter.render).to have_tag("span",
                                           with: expected_wrapper_attributes.merge(
                                             { "data-embed-code" => embed_code, "data-document-type" => "contact" },
                                           ),
                                           text: "0891 50 50 50")
    end
  end

  describe "when addresses are present" do
    let(:addresses) do
      {
        "some_address": {
          "title": "Some address",
          "street_address": "123 Fake Street",
          "town_or_city": "Springton",
          "state_or_county": "Missouri",
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
        "town_or_city": "Springton",
        "state_or_county": "Missouri",
        "postal_code": "TEST 123",
        "country": "USA",
      }])
    end

    it "should render successfully" do
      presenter = described_class.new(content_block)

      expect(presenter.render).to have_tag("div", with: expected_wrapper_attributes) do
        with_tag("div", with: { class: "contact" }) do
          with_tag("div", with: { class: "content" }) do
            with_tag("div", with: { class: "vcard contact-inner" }) do
              with_tag("p") do
                with_text "Some address,123 Fake Street,Springton,Missouri,TEST 123,USA"
                with_tag "br", count: 5
              end
            end
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

      expect(presenter.render).to have_tag("div", with: expected_wrapper_attributes.merge({ "data-embed-code" => embed_code, "data-document-type" => "contact" })) do
        with_tag(:div, with: { class: "contact" }) do
          with_text "Some address,123 Fake Street,Springton,Missouri,TEST 123,USA"
          with_tag "br", count: 5
        end
      end
    end
  end

  describe "when contact links are present" do
    let(:contact_links) do
      {
        "foo": {
          "title": "Some contact form",
          "url": "http://example.com",
        },
      }
    end

    it "should return the contact links" do
      presenter = described_class.new(content_block)

      expect(presenter.contact_links).to eq([{
        "title": "Some contact form",
        "url": "http://example.com",
      }])
    end

    it "should render successfully" do
      presenter = described_class.new(content_block)

      expect(presenter.render).to have_tag("div", with: expected_wrapper_attributes) do
        with_tag("div", with: { class: "contact" }) do
          with_tag("div", with: { class: "content" }) do
            with_tag("div", with: { class: "vcard contact-inner" }) do
              with_tag("p", text: "My Contact")
              with_tag("p") do
                with_tag("a", text: "http://example.com", with: { href: "http://example.com" })
              end
            end
          end
        end
      end
    end

    it "should render a contact form block when an embed code is provided" do
      embed_code = "{{embed:content_block_contact:#{content_id}/contact_links/foo}}"

      content_block = ContentBlockTools::ContentBlock.new(
        document_type: "contact",
        content_id:,
        title: "My Contact",
        details: { contact_links: contact_links, telephones: telephones },
        embed_code:,
      )

      presenter = described_class.new(content_block)

      expect(presenter.render).to have_tag("div", with: expected_wrapper_attributes.merge({ "data-embed-code" => embed_code, "data-document-type" => "contact" })) do
        with_tag("div", with: { class: "contact" }) do
          with_tag("div", with: { class: "email-url-number" }) do
            with_tag("p") do
              with_tag("a", text: "http://example.com", with: { href: "http://example.com" })
            end
          end
        end
      end
    end
  end

  context "with a description" do
    let(:description) { "Some description" }

    it "should render the description" do
      presenter = described_class.new(content_block)

      expect(presenter).to receive(:render_govspeak)
                             .with(description)
                             .and_call_original

      expect(presenter.render).to have_tag("div", with: expected_wrapper_attributes) do
        with_tag("div", with: { class: "contact" }) do
          with_tag("p", text: description)
        end
      end
    end
  end
end
