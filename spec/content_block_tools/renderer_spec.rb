RSpec.describe ContentBlockTools::Renderer do
  let(:content_id) { SecureRandom.uuid }
  let(:title) { "Test Block" }
  let(:embed_code) { "{{embed:content_block_time_period:#{content_id}}}" }

  let(:content_block) do
    ContentBlockTools::ContentBlock.new(
      content_id:,
      title:,
      document_type: "content_block_time_period",
      details: {
        date_range: {
          start: "2024-04-06",
          end: "2025-04-05",
        },
      },
      embed_code:,
    )
  end

  describe "#render" do
    subject(:rendered) { described_class.new(content_block).render }

    it "wraps content in a div with content-block classes" do
      expect(rendered).to have_tag("div.content-block.content-block--time_period")
    end

    it "includes data attributes" do
      expect(rendered).to have_tag(
        "div",
        with: {
          "data-content-block" => "",
          "data-document-type" => "time_period",
          "data-content-id" => content_id,
          "data-embed-code" => embed_code,
        },
      )
    end

    context "when rendering a component" do
      it "renders using the component" do
        expect(rendered).to have_tag("p.govuk-body", seen: "6 April 2024 to 5 April 2025")
      end
    end

    context "when no component exists for the document type" do
      let(:content_block) do
        ContentBlockTools::ContentBlock.new(
          content_id:,
          title:,
          document_type: "content_block_unknown",
          details: {},
          embed_code: "{{embed:content_block_unknown:#{content_id}}}",
        )
      end

      it "falls back to displaying the title" do
        expect(rendered).to have_tag("div", seen: title)
      end
    end

    context "when rendering a string field" do
      let(:embed_code) { "{{embed:content_block_contact:#{content_id}/email_addresses/main/email_address}}" }

      let(:content_block) do
        ContentBlockTools::ContentBlock.new(
          content_id:,
          title:,
          document_type: "content_block_contact",
          details: {
            email_addresses: {
              main: {
                title: "Email",
                email_address: "test@example.gov.uk",
              },
            },
          },
          embed_code:,
        )
      end

      it "renders using a span tag" do
        expect(rendered).to have_tag("span.content-block.content-block--contact")
      end

      it "renders the string field value" do
        expect(rendered).to include("test@example.gov.uk")
      end
    end

    context "when rendering a hash field in a one-to-one relationship" do
      let(:embed_code) { "{{embed:content_block_time_period:#{content_id}/date_range}}" }

      let(:content_block) do
        ContentBlockTools::ContentBlock.new(
          content_id:,
          title:,
          document_type: "content_block_time_period",
          details: {
            date_range: {
              start: "2024-04-06",
              end: "2025-04-05",
            },
          },
          embed_code:,
        )
      end

      it "renders using a div tag (block content)" do
        expect(rendered).to have_tag("div.content-block.content-block--time_period")
      end

      it "uses the field presenter for the hash" do
        expect(rendered).to include("6 April 2024")
        expect(rendered).to include("5 April 2025")
      end
    end

    context "when rendering a hash field with block_type and block_name" do
      let(:embed_code) { "{{embed:content_block_contact:#{content_id}/email_addresses/main}}" }

      let(:content_block) do
        ContentBlockTools::ContentBlock.new(
          content_id:,
          title:,
          document_type: "content_block_contact",
          details: {
            email_addresses: {
              main: {
                title: "Main Email",
                email_address: "main@example.gov.uk",
              },
            },
          },
          embed_code:,
        )
      end

      it "renders using the component with block_type and block_name" do
        expect(rendered).to have_tag("div.content-block.content-block--contact")
      end
    end

    context "when field content is not found" do
      before { allow(ContentBlockTools.logger).to receive(:warn) }

      let(:embed_code) { "{{embed:content_block_contact:#{content_id}/nonexistent/field}}" }

      let(:content_block) do
        ContentBlockTools::ContentBlock.new(
          content_id:,
          title:,
          document_type: "content_block_contact",
          details: {},
          embed_code:,
        )
      end

      it "logs a warning" do
        rendered

        expect(ContentBlockTools.logger).to have_received(:warn).with(
          "Content not found for content block #{content_id} and fields [:nonexistent, :field]",
        )
      end

      it "returns the embed code" do
        expect(rendered).to include(embed_code)
      end
    end
  end
end
