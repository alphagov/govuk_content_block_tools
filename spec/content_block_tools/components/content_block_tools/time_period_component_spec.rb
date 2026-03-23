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

    let(:format) { nil }

    let(:content_block) do
      ContentBlockTools::ContentBlock.new(
        document_type: "time_period",
        content_id: SecureRandom.uuid,
        title: "Tax year",
        details: details,
        embed_code: "{{embed:content_block_time_period:tax-year}}",
        format: format,
      )
    end

    let(:component) do
      described_class.new(content_block: content_block)
    end

    context "with default format" do
      it "presents the date range as pair of GovUK formatted dates" do
        expect(component.render).to have_tag(
          "p",
          with: { class: "govuk-body" },
          seen: "6 April 2025 to 5 April 2026",
        )
      end

      context "when the date range is not defined" do
        let(:details) { {} }

        it "renders nothing" do
          expect(component.render).not_to have_tag("p")
        end
      end
    end

    context "with explicit default format" do
      let(:format) { "default" }

      it "presents the full date range" do
        expect(component.render).to have_tag(
          "p",
          with: { class: "govuk-body" },
          seen: "6 April 2025 to 5 April 2026",
        )
      end
    end

    context "with long_form format" do
      let(:format) { "long_form" }

      it "presents month and year range" do
        expect(component.render).to have_tag(
          "p",
          with: { class: "govuk-body" },
          seen: "April 2025 to April 2026",
        )
      end

      context "when the date range is not defined" do
        let(:details) { {} }

        it "renders nothing" do
          expect(component.render).not_to have_tag("p")
        end
      end
    end

    context "with start_day_and_month format" do
      let(:format) { "start_day_and_month" }

      it "presents the start day and month only" do
        expect(component.render).to have_tag(
          "p",
          with: { class: "govuk-body" },
          seen: "6 April",
        )
      end

      context "when the date range is not defined" do
        let(:details) { {} }

        it "renders nothing" do
          expect(component.render).not_to have_tag("p")
        end
      end
    end

    context "with start_month_as_word format" do
      let(:format) { "start_month_as_word" }

      it "presents the start month only" do
        expect(component.render).to have_tag(
          "p",
          with: { class: "govuk-body" },
          seen: "April",
        )
      end

      context "when the date range is not defined" do
        let(:details) { {} }

        it "renders nothing" do
          expect(component.render).not_to have_tag("p")
        end
      end
    end

    context "with years format" do
      let(:format) { "years" }

      it "presents the year range with full years" do
        expect(component.render).to have_tag(
          "p",
          with: { class: "govuk-body" },
          seen: "2025-2026",
        )
      end

      context "when the date range is not defined" do
        let(:details) { {} }

        it "renders nothing" do
          expect(component.render).not_to have_tag("p")
        end
      end
    end

    context "with years_short format" do
      let(:format) { "years_short" }

      it "presents the year range with abbreviated end year" do
        expect(component.render).to have_tag(
          "p",
          with: { class: "govuk-body" },
          seen: "2025-26",
        )
      end

      context "when the date range is not defined" do
        let(:details) { {} }

        it "renders nothing" do
          expect(component.render).not_to have_tag("p")
        end
      end
    end

    context "with an invalid format" do
      let(:format) { "unknown_format" }

      it "raises an InvalidFormatError" do
        expect { component }.to raise_error(
          ContentBlockTools::InvalidFormatError,
          "Unknown format 'unknown_format' for time_period",
        )
      end
    end
  end
end
