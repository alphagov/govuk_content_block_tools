RSpec.describe ContentBlockTools::Renderer do
  let(:content_id) { SecureRandom.uuid }
  let(:title) { "Some Title" }
  let(:document_type) { "content_block_pension" }
  let(:details) { { some: "details" } }
  let(:embed_code) { "{{embed:content_block_pension:something}}" }
  let(:format) { ContentBlockTools::Format::DEFAULT_FORMAT }

  let(:content_block) do
    ContentBlockTools::ContentBlock.new(
      document_type:,
      content_id:,
      title:,
      details:,
      embed_code:,
      format:,
    )
  end

  let(:renderer) { described_class.new(content_block) }

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
          email_addresses: {
            something: {
              title: "Title",
              email: "foo@bar.com",
            },
          },
        }
      end

      let(:document_type) { "content_block_contact" }

      context "when embed code does not include any field or block references" do
        let(:embed_code) { "{{embed:content_block_contact:contact}}" }

        it "renders with the component" do
          expect(ContentBlockTools::ContactComponent)
            .to receive_message_chain(:new, :render)
                  .with(content_block:)
                  .with(no_args)
                  .and_return("CONTENT_BLOCK_CONTENT")

          expect(renderer.render).to have_tag("div", text: "CONTENT_BLOCK_CONTENT", with: expected_wrapper_attributes)
        end
      end

      context "when embed code references a block" do
        let(:embed_code) { "{{embed:content_block_contact:contact/email_addresses/something}}" }

        it "initializes the component with the block type and block name and renders" do
          expect(ContentBlockTools::ContactComponent)
            .to receive_message_chain(:new, :render)
                  .with(content_block:, block_type: "email_addresses", block_name: "something")
                  .with(no_args)
                  .and_return("CONTENT_BLOCK_CONTENT")

          expect(renderer.render).to have_tag("div", text: "CONTENT_BLOCK_CONTENT", with: expected_wrapper_attributes)
        end
      end

      context "when embed code references an email field" do
        let(:embed_code) { "{{embed:content_block_contact:contact/email_addresses/something/email}}" }

        it "uses the presenter to render the field" do
          expect(ContentBlockTools::Presenters::FieldPresenters::Contact::EmailPresenter)
            .to receive_message_chain(:new, :render)
                  .with("foo@bar.com")
                  .with(no_args)
                  .and_return("foo@bar.com")

          expect(renderer.render).to have_tag("span", text: "foo@bar.com", with: expected_wrapper_attributes)
        end
      end

      context "when embed code references another field" do
        let(:embed_code) { "{{embed:content_block_contact:contact/email_addresses/something/title}}" }

        it "uses the base presenter to render the field" do
          expect(ContentBlockTools::Presenters::FieldPresenters::BasePresenter)
            .to receive_message_chain(:new, :render)
                  .with("title")
                  .with(no_args)
                  .and_return("title")

          expect(renderer.render).to have_tag("span", text: "title", with: expected_wrapper_attributes)
        end
      end

      context "when embed code references a non-existent field" do
        let(:embed_code) { "{{embed:content_block_contact:contact/email_addresses/something/bleh}}" }

        it "logs a warning and returns the embed code" do
          expect(ContentBlockTools.logger).to receive(:warn)
            .with("Content not found for content block #{content_id} and fields [:email_addresses, :something, :bleh]")

          expect(renderer.render).to have_tag("span", text: embed_code, with: expected_wrapper_attributes)
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
          date_range: {
            start: {
              date: "2022-01-01",
              time: "00:00",
            },
            end: {
              date: "2022-12-31",
              time: "23:59",
            },
          },
        }
      end

      context "when embed code references the start date" do
        let(:embed_code) { "{{embed:content_block_time_period:current-calendar-year/date_range/start/date}}" }

        it "uses the date presenter to render the field" do
          expect(ContentBlockTools::Presenters::FieldPresenters::TimePeriod::DatePresenter)
            .to receive_message_chain(:new, :render)
                  .with("2022-01-01")
                  .with(no_args)
                  .and_return("1 January 2022")

          expect(renderer.render).to have_tag("span", text: "1 January 2022", with: expected_wrapper_attributes)
        end
      end

      context "when embed code references the start time" do
        let(:embed_code) { "{{embed:content_block_time_period:current-calendar-year/date_range/start/time}}" }

        it "uses the time presenter to render the field" do
          expect(ContentBlockTools::Presenters::FieldPresenters::TimePeriod::TimePresenter)
            .to receive_message_chain(:new, :render)
                  .with("00:00")
                  .with(no_args)
                  .and_return("midnight")

          expect(renderer.render).to have_tag("span", text: "midnight", with: expected_wrapper_attributes)
        end
      end

      context "when embed code does not include field references" do
        let(:embed_code) { "{{embed:content_block_time_period:current-calendar-year}}" }

        it "renders with the component" do
          expect(ContentBlockTools::TimePeriodComponent)
            .to receive_message_chain(:new, :render)
                  .with(content_block:)
                  .with(no_args)
                  .and_return("6 April 2025 to 5 April 2026")

          expect(renderer.render).to have_tag("div", text: "6 April 2025 to 5 April 2026", with: expected_wrapper_attributes)
        end
      end
    end

    context "with a pension block (no component)" do
      let(:document_type) { "content_block_pension" }
      let(:title) { "State Pension" }

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
          rates: {
            "full-basic-state-pension": {
              amount: "£123.45",
            },
          },
        }
      end

      context "when embed code does not include any field or block references" do
        let(:embed_code) { "{{embed:content_block_pension:pension}}" }

        it "returns the content block's title when no component exists" do
          expect(renderer.render).to have_tag("div", text: title, with: expected_wrapper_attributes)
        end
      end

      context "when embed code references a field" do
        let(:embed_code) { "{{embed:content_block_pension:pension/rates/full-basic-state-pension/amount}}" }

        it "uses the base presenter to render the field" do
          expect(ContentBlockTools::Presenters::FieldPresenters::BasePresenter)
            .to receive_message_chain(:new, :render)
                  .with("amount")
                  .with(no_args)
                  .and_return("£123.45")

          expect(renderer.render).to have_tag("span", text: "£123.45", with: expected_wrapper_attributes)
        end
      end
    end

    describe "HTML wrapper attributes" do
      let(:document_type) { "content_block_time_period" }
      let(:embed_code) { "{{embed:content_block_time_period:tax-year}}" }
      let(:details) do
        {
          date_range: {
            start: { date: "2025-04-06", time: "00:00" },
            end: { date: "2026-04-05", time: "23:59" },
          },
        }
      end

      before do
        allow(ContentBlockTools::TimePeriodComponent)
          .to receive_message_chain(:new, :render)
          .and_return("content")
      end

      it "includes the correct data attributes" do
        rendered = renderer.render

        expect(rendered).to have_tag("div", with: {
          "data-content-block" => "",
          "data-document-type" => "time_period",
          "data-content-id" => content_id,
          "data-embed-code" => embed_code,
        })
      end

      it "includes the correct CSS classes" do
        rendered = renderer.render

        expect(rendered).to have_tag("div", with: {
          class: "content-block content-block--time_period",
        })
      end
    end
  end
end
