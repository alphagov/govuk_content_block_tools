RSpec.describe ContentBlockTools::Presenters::FieldPresenters::TimePeriod::DateRangePresenter do
  describe "with legacy format" do
    let(:date_range) do
      {
        start: {
          date: "2025-04-06",
          time: "00:00",
        },
        end: {
          date: "2026-04-05",
          time: "23:59",
        },
      }
    end

    it "presents a date range in words, omitting time" do
      presenter = described_class.new(date_range)

      expect(presenter.render).to eq("6 April 2025 to 5 April 2026")
    end
  end

  describe "with ISO 8601 format" do
    let(:date_range) do
      {
        start: "2025-04-06T00:00:00+00:00",
        end: "2026-04-05T23:59:00+00:00",
      }
    end

    it "presents a date range in words, omitting time" do
      presenter = described_class.new(date_range)

      expect(presenter.render).to eq("6 April 2025 to 5 April 2026")
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
        start: "2025-04-06T00:00:00+00:00",
        end: "2026-04-05T23:59:00+00:00",
      }
    end

    it "produces identical output for both formats" do
      legacy = described_class.new(legacy_format)
      iso8601 = described_class.new(iso8601_format)

      expect(legacy.render).to eq(iso8601.render)
    end
  end

  context "when the date range is not defined" do
    it "renders nothing" do
      presenter = described_class.new({})

      expect(presenter.render).to be_nil
    end
  end

  describe "error handling" do
    context "when the expected start/end date key isn't found" do
      let(:date_range) do
        {
          other_key: {
            date: "2025-04-06",
            time: "00:00",
          },
        }
      end

      it "renders nothing" do
        presenter = described_class.new(date_range)

        expect(presenter.render).to be_nil
      end
    end

    context "when the legacy format date can't be parsed" do
      let(:date_range) do
        {
          start: {
            date: "Half past twelve",
            time: "00:00",
          },
          end: {
            date: "2026-04-05",
            time: "23:59",
          },
        }
      end

      it "raises an error with an informative message" do
        presenter = described_class.new(date_range)

        expect { presenter.render }.to raise_error(
          ContentBlockTools::Presenters::FieldPresenters::TimePeriod::TimePeriodPresenterError,
          /Not a valid date range:.*Invalid legacy date format/,
        )
      end
    end

    context "when the ISO 8601 format is invalid" do
      let(:date_range) do
        {
          start: "not-a-date",
          end: "2026-04-05T23:59:00+00:00",
        }
      end

      it "raises an error with an informative message" do
        presenter = described_class.new(date_range)

        expect { presenter.render }.to raise_error(
          ContentBlockTools::Presenters::FieldPresenters::TimePeriod::TimePeriodPresenterError,
          /Not a valid date range:.*Invalid ISO 8601 format/,
        )
      end
    end
  end
end
