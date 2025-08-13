RSpec.describe ContentBlockTools::ContactComponent do
  let(:content_id) { SecureRandom.uuid }
  let(:email_addresses) { {} }
  let(:telephones) { {} }
  let(:addresses) { {} }
  let(:contact_links) { {} }
  let(:description) { nil }

  let(:details) do
    {
      email_addresses: email_addresses,
      telephones: telephones,
      addresses: addresses,
      contact_links: contact_links,
      description:,
    }
  end

  let(:content_block) do
    ContentBlockTools::ContentBlock.new(
      document_type: "contact",
      content_id:,
      title: "My Contact",
      details:,
      embed_code: "something",
    )
  end

  describe "when no content items are present" do
    it "should render successfully" do
      component = described_class.new(content_block:)

      expect(component.render).to have_tag("dl", with: { class: "content-block__contact-list vcard" }) do
        with_tag("dt", text: "My Contact", with: { class: "content-block__contact-key fn org" })
      end
    end
  end

  describe "when a description is present" do
    let(:description) { "Something" }

    it "should include the description" do
      component = described_class.new(content_block:)

      expect(component).to receive(:render_govspeak)
                             .with(description)
                             .and_call_original

      expect(component.render).to have_tag("dl", with: { class: "vcard" }) do
        with_tag("p", text: description)
      end
    end

    described_class::BLOCK_TYPES.each do |block_type|
      context "when a #{block_type} block type is given" do
        let(:component) { described_class.new(content_block:, block_type:, block_name: "foo") }
        let(:component_for_block_type) { double("Component", new: double(render: "")) }

        before do
          expect(component)
            .to receive(:component_for_block_type)
                  .with(block_type)
                  .and_return(component_for_block_type)
        end

        it "should not include the description" do
          expect(component).not_to receive(:render_govspeak)
                                 .with(description)

          expect(component.render).to have_tag("dl", with: { class: "vcard" }) do
            without_tag("p", text: description)
          end
        end
      end
    end
  end

  describe "when an email address is present" do
    let(:email_addresses) do
      {
        "foo": {
          "title": "Some email address",
          "email_address": "foo@example.com",
        },
      }
    end

    before do
      expect(ContentBlockTools::Contacts::EmailAddressComponent)
        .to receive_message_chain(:new, :render)
              .with(item: email_addresses[:foo])
              .with(no_args)
              .and_return("<p>EMAIL ADDRESS</p>")
    end

    it "should render successfully" do
      component = described_class.new(content_block:)

      expect(component.render).to have_tag("dl", with: { class: "vcard" }) do
        with_tag("dt", text: "My Contact", with: { class: "content-block__contact-key fn org" })
        with_tag("dl", with: { class: "content-block__contact-list--nested" }) do
          with_tag("dt", text: email_addresses[:foo][:title])
          with_tag("dd", with: { class: "content-block__contact-value" }) do
            with_tag("p", text: "EMAIL ADDRESS")
          end
        end
      end
    end

    it "should render an individual block" do
      component = described_class.new(content_block:, block_type: "email_address", block_name: "foo")

      expect(component.render).to have_tag("dl", with: { class: "vcard" }) do
        without_tag("dl", with: { class: "content-block__contact-list--nested" })
        with_tag("dt", text: "My Contact", with: { class: "content-block__contact-key fn org" })
        without_tag("dt", text: email_addresses[:foo][:title])
        with_tag("dd", with: { class: "content-block__contact-value" }) do
          with_tag("p", text: "EMAIL ADDRESS")
        end
      end
    end
  end

  describe "when a telephone is present" do
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

    before do
      expect(ContentBlockTools::Contacts::TelephoneComponent)
        .to receive_message_chain(:new, :render)
              .with(item: telephones[:foo])
              .with(no_args)
              .and_return("<p>TELEPHONE</p>")
    end

    it "should render successfully" do
      component = described_class.new(content_block:)

      expect(component.render).to have_tag("dl", with: { class: "vcard" }) do
        with_tag("dt", text: "My Contact", with: { class: "content-block__contact-key fn org" })
        with_tag("dl", with: { class: "content-block__contact-list--nested" }) do
          with_tag("dt", text: telephones[:foo][:title])
          with_tag("dd", with: { class: "content-block__contact-value" }) do
            with_tag("p", text: "TELEPHONE")
          end
        end
      end
    end

    it "should render an individual block" do
      component = described_class.new(content_block:, block_type: "telephone", block_name: "foo")

      expect(component.render).to have_tag("dl", with: { class: "vcard" }) do
        without_tag("dl", with: { class: "content-block__contact-list--nested" })
        with_tag("dt", text: "My Contact", with: { class: "content-block__contact-key fn org" })
        without_tag("dt", text: telephones[:foo][:title])
        with_tag("dd", with: { class: "content-block__contact-value" }) do
          with_tag("p", text: "TELEPHONE")
        end
      end
    end
  end

  describe "when a address is present" do
    let(:addresses) do
      {
        "some_address": {
          "title": "Address",
          "recipient": "Department of something",
          "street_address": "123 Fake Street",
          "town_or_city": "Springton",
          "state_or_county": "Missouri",
          "postal_code": "TEST 123",
          "country": "USA",
        },
      }
    end

    before do
      expect(ContentBlockTools::Contacts::AddressComponent)
        .to receive_message_chain(:new, :render)
              .with(item: addresses[:some_address])
              .with(no_args)
              .and_return("<p>ADDRESS</p>")
    end

    it "should render successfully" do
      component = described_class.new(content_block:)

      expect(component.render).to have_tag("dl", with: { class: "vcard" }) do
        with_tag("dt", text: "My Contact", with: { class: "content-block__contact-key fn org" })
        with_tag("dl", with: { class: "content-block__contact-list--nested" }) do
          with_tag("dt", text: addresses[:some_address][:title])
          with_tag("dd", with: { class: "content-block__contact-value" }) do
            with_tag("p", text: "ADDRESS")
          end
        end
      end
    end

    it "should render an individual block" do
      component = described_class.new(content_block:, block_type: "address", block_name: "some_address")

      expect(component.render).to have_tag("dl", with: { class: "vcard" }) do
        with_tag("dt", text: "My Contact", with: { class: "content-block__contact-key fn org" })
        without_tag("dl", with: { class: "content-block__contact-list--nested" })
        without_tag("dt", text: addresses[:some_address][:title])
        with_tag("dd", with: { class: "content-block__contact-value" }) do
          with_tag("p", text: "ADDRESS")
        end
      end
    end
  end

  describe "when a contact link is present" do
    let(:contact_links) do
      {
        "foo": {
          "title": "Some contact form",
          "url": "http://example.com",
        },
      }
    end

    before do
      expect(ContentBlockTools::Contacts::ContactLinkComponent)
        .to receive_message_chain(:new, :render)
              .with(item: contact_links[:foo])
              .with(no_args)
              .and_return("<p>CONTACT LINK</p>")
    end

    it "should render successfully" do
      component = described_class.new(content_block:)

      expect(component.render).to have_tag("dl", with: { class: "vcard" }) do
        with_tag("dt", text: "My Contact", with: { class: "content-block__contact-key fn org" })
        with_tag("dl", with: { class: "content-block__contact-list--nested" }) do
          with_tag("dt", text: contact_links[:foo][:title])
          with_tag("dd", with: { class: "content-block__contact-value" }) do
            with_tag("p", text: "CONTACT LINK")
          end
        end
      end
    end

    it "should render an individual block" do
      component = described_class.new(content_block:, block_type: "contact_link", block_name: "foo")

      expect(component.render).to have_tag("dl", with: { class: "vcard" }) do
        with_tag("dt", text: "My Contact", with: { class: "content-block__contact-key fn org" })
        without_tag("dl", with: { class: "content-block__contact-list--nested" })
        without_tag("dt", text: contact_links[:foo][:title])
        with_tag("dd", with: { class: "content-block__contact-value" }) do
          with_tag("p", text: "CONTACT LINK")
        end
      end
    end
  end
end
