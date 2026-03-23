RSpec.describe ContentBlockTools::ContentBlock do
  let(:content_id) { SecureRandom.uuid }
  let(:title) { "Some Title" }
  let(:document_type) { "pension" }
  let(:details) { { some: "details" } }
  let(:embed_code) { "something" }

  let(:content_block) do
    described_class.new(
      document_type:,
      content_id:,
      title:,
      details:,
      embed_code:,
    )
  end

  it "initializes correctly" do
    expect(content_block.document_type).to eq(document_type)
    expect(content_block.content_id).to eq(content_id)
    expect(content_block.title).to eq(title)
    expect(content_block.details).to eq(details)
  end

  describe "::from_embed_code" do
    let(:embed_code) { "{{embed:content_block_pension:my-pension}}" }
    let(:api_response) do
      {
        "content_id" => "my-pension",
        "title" => "My Pension",
        "details" => { "some" => "details" },
        "document_type" => "content_block_pension",
      }
    end
    let(:reference) do
      double(ContentBlockTools::ContentBlockReference,
             document_type: "content_block_pension",
             identifier: "my-pension",
             embed_code: embed_code)
    end
    let(:content_store_identifier) { "/content-blocks/content_block_pension/my-pension" }
    let(:content_block) { double(ContentBlockTools::ContentBlock) }
    let(:content_store) { double(GdsApi::ContentStore) }

    before do
      allow(GdsApi).to receive(:content_store).and_return(content_store)
    end

    it "returns a content block" do
      expect(ContentBlockTools::ContentBlockReference).to receive(:from_string)
                                                            .with(embed_code)
                                                            .and_return(reference)

      expect(reference).to receive(:content_store_identifier)
                             .and_return(content_store_identifier)

      expect(content_store).to receive(:content_item)
                                 .with(content_store_identifier)
                                 .and_return(api_response)

      content_block = ContentBlockTools::ContentBlock.from_embed_code(embed_code)

      expect(content_block.content_id).to eq(api_response["content_id"])
      expect(content_block.title).to eq(api_response["title"])
      expect(content_block.details).to eq(api_response["details"].deep_symbolize_keys)
      expect(content_block.document_type).to eq("pension")
      expect(content_block.format).to eq(ContentBlockTools::Format::DEFAULT_FORMAT)
    end

    context "when the embed code includes a format" do
      let(:embed_code) { "{{embed:content_block_pension:my-pension|custom_format}}" }

      it "extracts the format from the embed code" do
        expect(ContentBlockTools::ContentBlockReference).to receive(:from_string)
                                                              .with(embed_code)
                                                              .and_return(reference)

        expect(reference).to receive(:content_store_identifier)
                               .and_return(content_store_identifier)

        expect(content_store).to receive(:content_item)
                                   .with(content_store_identifier)
                                   .and_return(api_response)

        content_block = ContentBlockTools::ContentBlock.from_embed_code(embed_code)

        expect(content_block.format).to eq("custom_format")
      end
    end
  end

  describe "#format" do
    context "when a format is provided" do
      let(:content_block) do
        described_class.new(
          document_type: document_type,
          content_id: content_id,
          title: title,
          details: details,
          embed_code: embed_code,
          format: "years_short",
        )
      end

      it "returns the format provided" do
        expect(content_block.format).to eq("years_short")
      end
    end

    context "when a format is NOT provided" do
      let(:content_block) do
        described_class.new(
          document_type: document_type,
          content_id: content_id,
          title: title,
          details: details,
          embed_code: embed_code,
          format: nil,
        )
      end

      it "returns the ContentBlockTools::Format::DEFAULT_FORMAT" do
        expect(content_block.format).to eq(ContentBlockTools::Format::DEFAULT_FORMAT)
      end
    end
  end

  describe "#details" do
    let(:details) do
      {
        "foo" => {
          "bar" => {
            "fizz" => "buzz",
          },
        },
      }
    end

    it "symbolizes the keys" do
      expect(content_block.details).to eq({ foo: { bar: { fizz: "buzz" } } })
    end
  end

  describe "#render" do
    context "with a contact block" do
      let(:expected_wrapper_attributes) do
        {
          class: "content-block content-block--contact",
          "data-content-block" => "",
          "data-document-type" => "contact",
          "data-content-id" => content_id,
          "data-embed-code" => embed_code,
        }
      end

      let(:details) do
        {
          "email_addresses": {
            "something": {
              "title" => "Title",
              "email" => "foo@bar.com",
            },
          },
        }
      end

      let(:document_type) { "content_block_contact" }

      context "embed code does not include any field or block references" do
        let(:embed_code) { "{{embed:content_block_contact:contact}}" }

        it "renders with the component" do
          expect(ContentBlockTools::ContactComponent)
            .to receive_message_chain(:new, :render)
                  .with(content_block:)
                  .with(no_args)
                  .and_return("CONTENT_BLOCK_CONTENT")

          expect(content_block.render).to have_tag("div", text: "CONTENT_BLOCK_CONTENT", with: expected_wrapper_attributes)
        end
      end

      context "embed code references a block" do
        let(:embed_code) { "{{embed:content_block_contact:contact/email_addresses/something}}" }

        it "initializes the component with the block type and block name and renders" do
          expect(ContentBlockTools::ContactComponent)
            .to receive_message_chain(:new, :render)
                  .with(content_block:, block_type: "email_addresses", block_name: "something")
                  .with(no_args)
                  .and_return("CONTENT_BLOCK_CONTENT")

          expect(content_block.render).to have_tag("div", text: "CONTENT_BLOCK_CONTENT", with: expected_wrapper_attributes)
        end
      end

      context "embed code references an email field" do
        let(:embed_code) { "{{embed:content_block_contact:contact/email_addresses/something/email}}" }

        it "uses the presenter to render the field" do
          expect(ContentBlockTools::Presenters::FieldPresenters::Contact::EmailPresenter)
            .to receive_message_chain(:new, :render)
                  .with("foo@bar.com")
                  .with(no_args)
                  .and_return("foo@bar.com")

          expect(content_block.render).to have_tag("span", text: "foo@bar.com", with: expected_wrapper_attributes)
        end
      end

      context "embed code references another field" do
        let(:embed_code) { "{{embed:content_block_contact:contact/email_addresses/something/title}}" }

        it "uses the presenter to render the field" do
          expect(ContentBlockTools::Presenters::FieldPresenters::BasePresenter)
            .to receive_message_chain(:new, :render)
                  .with("title")
                  .with(no_args)
                  .and_return("title")

          expect(content_block.render).to have_tag("span", text: "title", with: expected_wrapper_attributes)
        end
      end

      context "embed code references a non-existent field" do
        let(:embed_code) { "{{embed:content_block_contact:contact/email_addresses/something/bleh}}" }

        it "uses the presenter to render the field" do
          expect(ContentBlockTools.logger).to receive(:warn).with("Content not found for content block #{content_id} and fields [:email_addresses, :something, :bleh]")

          expect(content_block.render).to have_tag("span", text: embed_code, with: expected_wrapper_attributes)
        end
      end
    end

    context "with a time period block" do
      let(:document_type) { "content_block_time_period" }

      let(:expected_wrapper_attributes) do
        {
          class: "content-block content-block--time_period",
          "data-content-block" => "",
          "data-document-type" => "time_period",
          "data-content-id" => content_id,
          "data-embed-code" => embed_code,
        }
      end

      let(:details) do
        {
          "date_range" => {
            "start" => {
              "date" => "2022-01-01",
              "time" => "00:00",
            },
            "end" => {
              "date" => "2022-12-31",
              "time" => "23:59",
            },
          },
        }
      end

      context "embed code references the start date" do
        let(:embed_code) { "{{embed:content_block_time_period:current-calendar-year/date_range/start/date}}" }

        it "uses the presenter to render the field" do
          expect(ContentBlockTools::Presenters::FieldPresenters::TimePeriod::DatePresenter)
            .to receive_message_chain(:new, :render)
                  .with("2022-01-01")
                  .with(no_args)
                  .and_return("1 January 2022")

          expect(content_block.render).to have_tag("span", text: "1 January 2022", with: expected_wrapper_attributes)
        end
      end

      context "embed code references the start time" do
        let(:embed_code) { "{{embed:content_block_time_period:current-calendar-year/date_range/start/time}}" }

        it "calls the time presenter and returns the value of the field" do
          expect(ContentBlockTools::Presenters::FieldPresenters::TimePeriod::TimePresenter)
            .to receive_message_chain(:new, :render)
                  .with("00:00")
                  .with(no_args)
                  .and_return("midnight")

          expect(content_block.render).to have_tag("span", text: "midnight", with: expected_wrapper_attributes)
        end
      end

      context "embed code references the end date" do
        let(:embed_code) { "{{embed:content_block_time_period:current-calendar-year/date_range/end/date}}" }

        it "uses the presenter to render the field" do
          expect(ContentBlockTools::Presenters::FieldPresenters::TimePeriod::DatePresenter)
            .to receive_message_chain(:new, :render)
                  .with("2022-12-31")
                  .with(no_args)
                  .and_return("31 December 2022")

          expect(content_block.render).to have_tag("span", text: "31 December 2022", with: expected_wrapper_attributes)
        end
      end

      context "embed code references the end time" do
        let(:embed_code) { "{{embed:content_block_time_period:current-calendar-year/date_range/end/time}}" }

        it "calls the time presenter and returns the value of the field" do
          expect(ContentBlockTools::Presenters::FieldPresenters::TimePeriod::TimePresenter)
            .to receive_message_chain(:new, :render)
                  .with("23:59")
                  .with(no_args)
                  .and_return("11:59pm")

          expect(content_block.render).to have_tag("span", text: "11:59pm", with: expected_wrapper_attributes)
        end
      end
    end

    context "with a time period's date_range" do
      let(:title) { "Tax year" }
      let(:document_type) { "content_block_time_period" }
      let(:details) do
        {
          "date_range" => {
            "start" => { "date" => "2025-04-06", "time" => "00:00" },
            "end" => { "date" => "2026-04-05", "time" => "23:59" },
          },
        }
      end

      let(:embed_code) { "{{embed:content_block_time_period:tax-year/date_range/}}" }

      let(:expected_wrapper_attributes) do
        {
          class: "content-block content-block--time_period",
          "data-content-block" => "",
          "data-document-type" => "time_period",
          "data-content-id" => content_id,
          "data-embed-code" => embed_code,
        }
      end

      let(:content_block) do
        described_class.new(
          document_type: document_type,
          content_id: content_id,
          title: title,
          details: details,
          embed_code: embed_code,
        )
      end

      before do
        expect(ContentBlockTools::Presenters::FieldPresenters::TimePeriod::DateRangePresenter)
          .to receive_message_chain(:new, :render)
            .with(details.fetch("date_range"))
            .with(no_args)
            .and_return("6 April 2025 to 5 April 2026")
      end

      it "returns the rendered presentation of the date_range field" do
        expect(content_block.render).to have_tag(
          "div",
          text: "6 April 2025 to 5 April 2026",
          with: expected_wrapper_attributes,
        )
      end
    end

    context "with a pension block" do
      let(:document_type) { "content_block_pension" }

      let(:expected_wrapper_attributes) do
        {
          class: "content-block content-block--pension",
          "data-content-block" => "",
          "data-document-type" => "pension",
          "data-content-id" => content_id,
          "data-embed-code" => embed_code,
        }
      end

      let(:details) do
        {
          "rates" => {
            "full-basic-state-pension" => {
              "amount" => "£123.45",
            },
          },
        }
      end

      context "embed code does not include any field or block references" do
        let(:embed_code) { "{{embed:content_block_contact:pension}}" }

        it "returns the content block's title" do
          expect(content_block.render).to have_tag("div", text: content_block.title, with: expected_wrapper_attributes)
        end
      end

      context "embed code references a field" do
        let(:embed_code) { "{{embed:content_block_contact:pension/rates/full-basic-state-pension/amount}}" }

        it "calls the base presenter and returns the value of the field" do
          expect(ContentBlockTools::Presenters::FieldPresenters::BasePresenter)
            .to receive_message_chain(:new, :render)
                  .with("title")
                  .with(no_args)
                  .and_return("£123.45")

          expect(content_block.render).to have_tag("span", text: "£123.45", with: expected_wrapper_attributes)
        end
      end
    end
  end
end
