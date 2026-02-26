RSpec.describe ContentBlockTools::ContactComponent do
  include ContentBlockTools::OverrideClasses

  shared_examples "renders with the correct override classes" do
    let(:component) { described_class.new(content_block:) }

    it "adds the correct override classes to the definition list" do
      expect(component.render).to have_tag("dl[class='#{margin_classes(0)} #{padding_classes(0)}']")
    end

    it "adds the correct override classes to the description terms" do
      expect(component.render).to have_tag("dt[class='#{margin_classes(0, 0, 4, 0)} #{padding_classes(0)} #{font_classes(19, 'bold')}']")
    end

    it "adds the correct override classes to the description definitions" do
      expect(component.render).to have_tag("dd[class='#{margin_classes(0, 0, 6, 0)}']")
    end
  end

  let(:content_id) { SecureRandom.uuid }
  let(:email_addresses) do
    {
      "foo": {
        "title": "Some email address",
        "email_address": "foo@example.com",
      },
    }
  end
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
  let(:contact_links) do
    {
      "foo": {
        "title": "Some contact form",
        "url": "http://example.com",
      },
    }
  end
  let(:description) { "Something" }

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
    let(:details) do
      {
        email_addresses: {},
        telephones: {},
        addresses: {},
        contact_links: {},
        description: nil,
      }
    end

    it "should render successfully" do
      component = described_class.new(content_block:)

      expect(component.render).to have_tag("div", with: { class: "vcard" })
    end
  end

  describe "when a description is present" do
    let(:details) do
      {
        email_addresses: {},
        telephones: {},
        addresses: {},
        contact_links: {},
        description: description,
      }
    end

    it "should include the description" do
      component = described_class.new(content_block:)

      expect(component).to receive(:render_govspeak)
                             .with(description)
                             .and_call_original

      expect(component.render).to have_tag("div", with: { class: "vcard" }) do
        with_tag("div", with: { "data-diff-key" => "description" }) do
          with_tag("p", text: description)
        end
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

          expect(component.render).to have_tag("div", with: { class: "vcard" }) do
            without_tag("p", text: description)
          end
        end
      end
    end
  end

  describe "when an email address is present" do
    let(:details) do
      {
        email_addresses:,
        telephones: {},
        addresses: {},
        contact_links: {},
        description: nil,
      }
    end

    before do
      expect(ContentBlockTools::Contacts::EmailAddressComponent)
        .to receive_message_chain(:new, :render)
              .with(item: email_addresses[:foo])
              .with(no_args)
              .and_return("<p>EMAIL ADDRESS</p>")
    end

    include_examples "renders with the correct override classes"

    it "should render successfully" do
      component = described_class.new(content_block:)

      expect(component.render).to have_tag("div", with: { class: "vcard" }) do
        with_tag("dl") do
          with_tag("div", with: { "data-diff-key" => "email_addresses-foo" }) do
            with_tag("dt", text: /#{email_addresses[:foo][:title]}/)
            with_tag("dd") do
              with_tag("p", text: "EMAIL ADDRESS")
            end
          end
        end
      end
    end

    it "should render an individual block" do
      component = described_class.new(content_block:, block_type: "email_address", block_name: "foo")

      expect(component.render).to have_tag("div", with: { class: "vcard" }) do
        without_tag("dl")
        without_tag("div", with: { "data-diff-key" => "email_addresses-foo" })
        without_tag("dt", text: email_addresses[:foo][:title])
        with_tag("p", text: "EMAIL ADDRESS")
      end
    end
  end

  describe "when a telephone is present" do
    let(:details) do
      {
        email_addresses: {},
        telephones:,
        addresses: {},
        contact_links: {},
        description: nil,
      }
    end

    before do
      expect(ContentBlockTools::Contacts::TelephoneComponent)
        .to receive_message_chain(:new, :render)
              .with(item: telephones[:foo])
              .with(no_args)
              .and_return("<p>TELEPHONE</p>")
    end

    include_examples "renders with the correct override classes"

    it "should render successfully" do
      component = described_class.new(content_block:)

      expect(component.render).to have_tag("div", with: { class: "vcard" }) do
        with_tag("dl") do
          with_tag("div", with: { "data-diff-key" => "telephones-foo" }) do
            with_tag("dt", text: /#{telephones[:foo][:title]}/)
            with_tag("dd") do
              with_tag("p", text: "TELEPHONE")
            end
          end
        end
      end
    end

    it "should render an individual block" do
      component = described_class.new(content_block:, block_type: "telephone", block_name: "foo")

      expect(component.render).to have_tag("div", with: { class: "vcard" }) do
        without_tag("dl")
        without_tag("div", with: { "data-diff-key" => "telephones-foo" })
        without_tag("dt", text: telephones[:foo][:title])
        with_tag("p", text: "TELEPHONE")
      end
    end
  end

  describe "when a address is present" do
    let(:details) do
      {
        email_addresses: {},
        telephones: {},
        addresses:,
        contact_links: {},
        description: nil,
      }
    end

    before do
      expect(ContentBlockTools::Contacts::AddressComponent)
        .to receive_message_chain(:new, :render)
              .with(item: addresses[:some_address])
              .with(no_args)
              .and_return("<p>ADDRESS</p>")
    end

    include_examples "renders with the correct override classes"

    it "should render successfully" do
      component = described_class.new(content_block:)

      expect(component.render).to have_tag("div", with: { class: "vcard" }) do
        with_tag("dl") do
          with_tag("div", with: { "data-diff-key" => "addresses-some_address" }) do
            with_tag("dt", text: /#{addresses[:some_address][:title]}/)
            with_tag("dd") do
              with_tag("p", text: "ADDRESS")
            end
          end
        end
      end
    end

    it "should render an individual block" do
      component = described_class.new(content_block:, block_type: "address", block_name: "some_address")

      expect(component.render).to have_tag("div", with: { class: "vcard" }) do
        without_tag("dl")
        without_tag("div", with: { "data-diff-key" => "addresses-some_address" })
        without_tag("dt", text: /#{addresses[:some_address][:title]}/)
        with_tag("p", text: "ADDRESS")
      end
    end
  end

  describe "when a contact link is present" do
    let(:details) do
      {
        email_addresses: {},
        telephones: {},
        addresses: {},
        contact_links:,
        description: nil,
      }
    end

    before do
      expect(ContentBlockTools::Contacts::ContactLinkComponent)
        .to receive_message_chain(:new, :render)
              .with(item: contact_links[:foo])
              .with(no_args)
              .and_return("<p>CONTACT LINK</p>")
    end

    include_examples "renders with the correct override classes"

    it "should render successfully" do
      component = described_class.new(content_block:)

      expect(component.render).to have_tag("div", with: { class: "vcard" }) do
        with_tag("dl") do
          with_tag("div", with: { "data-diff-key" => "contact_links-foo" }) do
            with_tag("dt", text: /#{contact_links[:foo][:title]}/)
            with_tag("dd") do
              with_tag("p", text: "CONTACT LINK")
            end
          end
        end
      end
    end

    it "should render an individual block" do
      component = described_class.new(content_block:, block_type: "contact_link", block_name: "foo")

      expect(component.render).to have_tag("div", with: { class: "vcard" }) do
        without_tag("dl")
        without_tag("div", with: { "data-diff-key" => "contact_links-foo" })
        without_tag("dt", text: /#{contact_links[:foo][:title]}/)
        with_tag("p", text: "CONTACT LINK")
      end
    end
  end

  describe "when multiple types are present" do
    let(:details) do
      {
        email_addresses:,
        telephones:,
        addresses:,
        contact_links:,
        description: nil,
        order:,
      }
    end

    let(:component_double) { double(:component, render: "") }

    context "when an order is not given" do
      let(:order) { nil }

      it "should call the components in the default order" do
        expect(ContentBlockTools::Contacts::AddressComponent)
          .to receive(:new).ordered.with(item: addresses.values.first)
                           .and_return(component_double)

        expect(ContentBlockTools::Contacts::EmailAddressComponent)
          .to receive(:new).ordered.with(item: email_addresses.values.first)
                           .and_return(component_double)

        expect(ContentBlockTools::Contacts::TelephoneComponent)
          .to receive(:new).ordered.with(item: telephones.values.first)
                           .and_return(component_double)

        expect(ContentBlockTools::Contacts::ContactLinkComponent)
          .to receive(:new).ordered.with(item: contact_links.values.first)
                           .and_return(component_double)

        described_class.new(content_block:).render
      end
    end

    context "when an order is given" do
      let(:order) {  %w[telephones.foo addresses.some_address contact_links.foo email_addresses.foo] }

      it "calls the components in the specified order" do
        expect(ContentBlockTools::Contacts::TelephoneComponent)
          .to receive(:new).ordered.with(item: telephones.values.first)
                           .and_return(component_double)

        expect(ContentBlockTools::Contacts::AddressComponent)
          .to receive(:new).ordered.with(item: addresses.values.first)
                           .and_return(component_double)

        expect(ContentBlockTools::Contacts::ContactLinkComponent)
          .to receive(:new).ordered.with(item: contact_links.values.first)
                           .and_return(component_double)

        expect(ContentBlockTools::Contacts::EmailAddressComponent)
          .to receive(:new).ordered.with(item: email_addresses.values.first)
                           .and_return(component_double)

        described_class.new(content_block:).render
      end
    end

    context "when some items are missing" do
      let(:order) { %w[contact_links.foo email_addresses.foo] }

      it "calls the excluded items last" do
        expect(ContentBlockTools::Contacts::ContactLinkComponent)
          .to receive(:new).ordered.with(item: contact_links.values.first)
                           .and_return(component_double)

        expect(ContentBlockTools::Contacts::EmailAddressComponent)
          .to receive(:new).ordered.with(item: email_addresses.values.first)
                           .and_return(component_double)

        expect(ContentBlockTools::Contacts::AddressComponent)
          .to receive(:new).ordered.with(item: addresses.values.first)
                           .and_return(component_double)

        expect(ContentBlockTools::Contacts::TelephoneComponent)
          .to receive(:new).ordered.with(item: telephones.values.first)
                           .and_return(component_double)

        described_class.new(content_block:).render
      end
    end

    context "when there are multiple items of the same type" do
      let(:email_addresses) do
        {
          "foo": {
            "title": "Some email address",
            "email_address": "foo@example.com",
          },
          "bar": {
            "title": "Other email address",
            "email_address": "bar@example.com",
          },
        }
      end

      let(:order) { %w[email_addresses.foo addresses.some_address contact_links.foo telephones.foo email_addresses.bar] }

      it "calls the components in the specified order" do
        expect(ContentBlockTools::Contacts::EmailAddressComponent)
          .to receive(:new).ordered.with(item: email_addresses.values.first)
                           .and_return(component_double)

        expect(ContentBlockTools::Contacts::AddressComponent)
          .to receive(:new).ordered.with(item: addresses.values.first)
                           .and_return(component_double)

        expect(ContentBlockTools::Contacts::ContactLinkComponent)
          .to receive(:new).ordered.with(item: contact_links.values.first)
                           .and_return(component_double)

        expect(ContentBlockTools::Contacts::TelephoneComponent)
          .to receive(:new).ordered.with(item: telephones.values.last)
                           .and_return(component_double)

        expect(ContentBlockTools::Contacts::EmailAddressComponent)
          .to receive(:new).ordered.with(item: email_addresses.values.last)
                           .and_return(component_double)

        described_class.new(content_block:).render
      end
    end
  end
end
