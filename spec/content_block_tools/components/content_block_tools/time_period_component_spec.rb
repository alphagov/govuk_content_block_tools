RSpec.describe ContentBlockTools::TimePeriodComponent do
  describe "#render" do
    let(:content_block) do
      ContentBlockTools::ContentBlock.new(
        document_type: "time_period",
        content_id: SecureRandom.uuid,
        title: "Tax year",
        details: details,
        embed_code: "{{embed:content_block_time_period:tax-year}}",
      )
    end

    let(:component) do
      described_class.new(content_block: content_block)
    end

    context "with legacy format" do
      let(:details) do
        {
          "date_range" => {
            "start" => { "date" => "2025-04-06", "time" => "00:00" },
            "end" => { "date" => "2026-04-05", "time" => "23:59" },
          },
        }
      end

      it "presents the date range as pair of GovUK formatted dates" do
        expect(component.render).to have_tag(
          "p",
          with: { class: "govuk-body" },
          seen: "6 April 2025 to 5 April 2026",
        )
      end
    end

    context "with ISO 8601 format" do
      let(:details) do
        {
          "date_range" => {
            "start" => "2025-04-06T00:00:00+00:00",
            "end" => "2026-04-05T23:59:00+00:00",
          },
        }
      end

      it "presents the date range as pair of GovUK formatted dates" do
        expect(component.render).to have_tag(
          "p",
          with: { class: "govuk-body" },
          seen: "6 April 2025 to 5 April 2026",
        )
      end
    end

    context "when both formats produce identical output" do
      let(:legacy_details) do
        {
          "date_range" => {
            "start" => { "date" => "2025-04-06", "time" => "00:00" },
            "end" => { "date" => "2026-04-05", "time" => "23:59" },
          },
        }
      end

      let(:iso8601_details) do
        {
          "date_range" => {
            "start" => "2025-04-06T00:00:00+00:00",
            "end" => "2026-04-05T23:59:00+00:00",
          },
        }
      end

      it "renders the same output for both formats" do
        legacy_block = ContentBlockTools::ContentBlock.new(
          document_type: "time_period",
          content_id: SecureRandom.uuid,
          title: "Tax year",
          details: legacy_details,
          embed_code: "{{embed:content_block_time_period:tax-year}}",
        )

        iso8601_block = ContentBlockTools::ContentBlock.new(
          document_type: "time_period",
          content_id: SecureRandom.uuid,
          title: "Tax year",
          details: iso8601_details,
          embed_code: "{{embed:content_block_time_period:tax-year}}",
        )

        legacy_component = described_class.new(content_block: legacy_block)
        iso8601_component = described_class.new(content_block: iso8601_block)

        expect(legacy_component.render).to eq(iso8601_component.render)
      end
    end

    context "when the date range is not defined" do
      let(:details) { {} }

      it "renders nothing" do
        expect(component.render).not_to have_tag("p")
      end
    end
  end
end
