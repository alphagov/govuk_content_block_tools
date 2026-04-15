RSpec.describe ContentBlockTools::TimePeriodComponent do
  describe "#render" do
    let(:content_id) { SecureRandom.uuid }
    let(:embed_code) { "{{embed:content_block_time_period:tax-year}}" }

    let(:content_block) do
      ContentBlockTools::ContentBlock.new(
        document_type: "time_period",
        content_id: content_id,
        title: "Tax year",
        details: details,
        embed_code: embed_code,
      )
    end

    let(:component) do
      described_class.new(content_block: content_block)
    end

    let(:details) do
      {
        "date_range" => {
          "start" => "2025-04-06T00:00:00+00:00",
          "end" => "2026-04-05T23:59:00+00:00",
        },
      }
    end

    describe "default format" do
      it "renders the same output as long_form" do
        default_block = ContentBlockTools::ContentBlock.new(
          document_type: "time_period",
          content_id: SecureRandom.uuid,
          title: "Tax year",
          details: details,
          embed_code: "{{embed:content_block_time_period:tax-year}}",
        )

        long_form_block = ContentBlockTools::ContentBlock.new(
          document_type: "time_period",
          content_id: SecureRandom.uuid,
          title: "Tax year",
          details: details,
          embed_code: "{{embed:content_block_time_period:tax-year|long_form}}",
        )

        default_component = described_class.new(content_block: default_block)
        long_form_component = described_class.new(content_block: long_form_block)

        expect(default_component.render).to eq(long_form_component.render)
      end

      context "with legacy format details" do
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

      context "with ISO 8601 format details" do
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
          expect(component.render).to eq("")
        end
      end
    end

    describe "long_form format" do
      let(:embed_code) { "{{embed:content_block_time_period:tax-year|long_form}}" }

      it "renders the full date range" do
        expect(component.render).to have_tag(
          "p",
          with: { class: "govuk-body" },
          seen: "6 April 2025 to 5 April 2026",
        )
      end
    end

    describe "months_and_years_long format" do
      let(:embed_code) { "{{embed:content_block_time_period:tax-year|months_and_years_long}}" }

      it "renders month and year only" do
        expect(component.render).to have_tag(
          "p",
          with: { class: "govuk-body" },
          seen: "April 2025 to April 2026",
        )
      end
    end

    describe "start_day_and_month format" do
      let(:embed_code) { "{{embed:content_block_time_period:tax-year|start_day_and_month}}" }

      it "renders only the start day and month" do
        expect(component.render).to have_tag(
          "p",
          with: { class: "govuk-body" },
          seen: "6 April",
        )
      end
    end

    describe "start_month_as_word format" do
      let(:embed_code) { "{{embed:content_block_time_period:tax-year|start_month_as_word}}" }

      it "renders only the start month" do
        expect(component.render).to have_tag(
          "p",
          with: { class: "govuk-body" },
          seen: "April",
        )
      end
    end

    describe "years format" do
      let(:embed_code) { "{{embed:content_block_time_period:tax-year|years}}" }

      it "renders the year range with full years" do
        expect(component.render).to have_tag(
          "p",
          with: { class: "govuk-body" },
          seen: "2025-2026",
        )
      end
    end

    describe "years_short format" do
      let(:embed_code) { "{{embed:content_block_time_period:tax-year|years_short}}" }

      it "renders the year range with abbreviated end year" do
        expect(component.render).to have_tag(
          "p",
          with: { class: "govuk-body" },
          seen: "2025-26",
        )
      end
    end

    describe "invalid format" do
      let(:embed_code) { "{{embed:content_block_time_period:tax-year|unknown_format}}" }

      it "raises InvalidFormatError" do
        expect { component }.to raise_error(
          ContentBlockTools::InvalidFormatError,
          "Unknown format 'unknown_format' for time_period",
        )
      end
    end
  end
end
