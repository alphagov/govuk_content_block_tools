RSpec.describe ContentBlockTools::NormalisedDateRange do
  describe "legacy format" do
    let(:date_range) do
      {
        start: { date: "2025-04-06", time: "00:00" },
        end: { date: "2026-04-05", time: "23:59" },
      }
    end

    it "returns the start time as a Time object" do
      normalised = described_class.new(date_range)

      expect(normalised.start_time).to be_a(ActiveSupport::TimeWithZone)
      expect(normalised.start_time).to eq(Time.zone.parse("2025-04-06 00:00"))
    end

    it "returns the end time as a Time object" do
      normalised = described_class.new(date_range)

      expect(normalised.end_time).to be_a(ActiveSupport::TimeWithZone)
      expect(normalised.end_time).to eq(Time.zone.parse("2026-04-05 23:59"))
    end

    it "returns the start date as a Date object" do
      normalised = described_class.new(date_range)

      expect(normalised.start_date).to eq(Date.new(2025, 4, 6))
    end

    it "returns the end date as a Date object" do
      normalised = described_class.new(date_range)

      expect(normalised.end_date).to eq(Date.new(2026, 4, 5))
    end

    context "when time is missing" do
      let(:date_range) do
        {
          start: { date: "2025-04-06" },
          end: { date: "2026-04-05" },
        }
      end

      it "parses with date only" do
        normalised = described_class.new(date_range)

        expect(normalised.start_date).to eq(Date.new(2025, 4, 6))
        expect(normalised.end_date).to eq(Date.new(2026, 4, 5))
      end
    end
  end

  describe "ISO 8601 format" do
    let(:date_range) do
      {
        start: "2025-04-06T00:00:00+01:00",
        end: "2026-04-05T23:59:00+01:00",
      }
    end

    it "returns the start time as a Time object" do
      normalised = described_class.new(date_range)

      expect(normalised.start_time).to be_a(Time)
      expect(normalised.start_time).to eq(Time.parse("2025-04-06T00:00:00+01:00"))
    end

    it "returns the end time as a Time object" do
      normalised = described_class.new(date_range)

      expect(normalised.end_time).to be_a(Time)
      expect(normalised.end_time).to eq(Time.parse("2026-04-05T23:59:00+01:00"))
    end

    it "returns the start date as a Date object" do
      normalised = described_class.new(date_range)

      expect(normalised.start_date).to eq(Date.new(2025, 4, 6))
    end

    it "returns the end date as a Date object" do
      normalised = described_class.new(date_range)

      expect(normalised.end_date).to eq(Date.new(2026, 4, 5))
    end

    context "with non-UTC timezone offset" do
      let(:date_range) do
        {
          start: "2025-04-06T00:00:00+01:00",
          end: "2026-04-05T23:59:00+01:00",
        }
      end

      it "extracts the date from the original timezone, not UTC" do
        normalised = described_class.new(date_range)

        expect(normalised.start_date).to eq(Date.new(2025, 4, 6))
        expect(normalised.end_date).to eq(Date.new(2026, 4, 5))
      end
    end
  end

  describe "format consistency" do
    let(:legacy_format) do
      {
        start: { date: "2025-04-06", time: "00:00" },
        end: { date: "2026-04-05", time: "23:59" },
      }
    end

    let(:iso8601_format) do
      {
        start: "2025-04-06T00:00:00+01:00",
        end: "2026-04-05T23:59:00+01:00",
      }
    end

    it "produces identical dates from both formats" do
      legacy = described_class.new(legacy_format)
      iso8601 = described_class.new(iso8601_format)

      expect(legacy.start_date).to eq(iso8601.start_date)
      expect(legacy.end_date).to eq(iso8601.end_date)
    end
  end

  describe "missing or empty data" do
    context "when date_range is nil" do
      it "returns nil for all values" do
        normalised = described_class.new(nil)

        expect(normalised.start_time).to be_nil
        expect(normalised.end_time).to be_nil
        expect(normalised.start_date).to be_nil
        expect(normalised.end_date).to be_nil
      end
    end

    context "when date_range is empty" do
      it "returns nil for all values" do
        normalised = described_class.new({})

        expect(normalised.start_time).to be_nil
        expect(normalised.end_time).to be_nil
        expect(normalised.start_date).to be_nil
        expect(normalised.end_date).to be_nil
      end
    end

    context "when start is missing" do
      let(:date_range) do
        { end: "2026-04-05T23:59:00+01:00" }
      end

      it "returns nil for start values" do
        normalised = described_class.new(date_range)

        expect(normalised.start_time).to be_nil
        expect(normalised.start_date).to be_nil
        expect(normalised.end_time).to be_present
      end
    end

    context "when legacy format date field is blank" do
      let(:date_range) do
        {
          start: { date: "", time: "00:00" },
          end: { date: "2026-04-05", time: "23:59" },
        }
      end

      it "returns nil for the blank endpoint" do
        normalised = described_class.new(date_range)

        expect(normalised.start_time).to be_nil
        expect(normalised.start_date).to be_nil
      end
    end
  end

  describe "error handling" do
    context "when ISO 8601 string is invalid" do
      let(:date_range) do
        {
          start: "not-a-date",
          end: "2026-04-05T23:59:00+01:00",
        }
      end

      it "raises a ParseError" do
        normalised = described_class.new(date_range)

        expect { normalised.start_time }.to raise_error(
          ContentBlockTools::NormalisedDateRange::ParseError,
          /Invalid ISO 8601 format/,
        )
      end
    end

    context "when legacy format date is invalid" do
      let(:date_range) do
        {
          start: { date: "not-a-date", time: "00:00" },
          end: { date: "2026-04-05", time: "23:59" },
        }
      end

      it "raises a ParseError" do
        normalised = described_class.new(date_range)

        expect { normalised.start_time }.to raise_error(
          ContentBlockTools::NormalisedDateRange::ParseError,
          /Invalid legacy date format/,
        )
      end
    end
  end
end
