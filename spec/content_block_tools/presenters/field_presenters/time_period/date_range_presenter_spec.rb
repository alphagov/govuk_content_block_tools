RSpec.describe ContentBlockTools::Presenters::FieldPresenters::TimePeriod::DateRangePresenter do
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

      it "raises an error with an informative message" do
        presenter = described_class.new(date_range)

        expect { presenter.render }.to raise_error(
          ContentBlockTools::Presenters::FieldPresenters::TimePeriod::TimePeriodPresenterError,
          "Not a valid date range: #{date_range}",
        )
      end
    end

    context "when the value found can't be parsed as a date" do
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
          "Not a valid date range: #{date_range}",
        )
      end
    end
  end
end
