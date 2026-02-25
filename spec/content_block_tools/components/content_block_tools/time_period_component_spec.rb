RSpec.describe ContentBlockTools::TimePeriodComponent do
  describe "#render" do
    let(:details) do
      {
        "date_range" => {
          "start" => { "date" => "2025-04-06", "time" => "00:00" },
          "end" => { "date" => "2026-04-05", "time" => "23:59" },
        },
      }
    end

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

    it "presents the date range as pair of GovUK formatted dates" do
      expect(component.render).to have_tag(
        "p",
        with: { class: "govuk-body" },
        seen: "6 April 2025 to 5 April 2026",
      )
    end
  end
end
