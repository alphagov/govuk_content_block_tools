RSpec.describe ContentBlockTools::Presenters::FieldPresenters::TimePeriod::DatePresenter do
  context "when the given param is a string representation" do
    context "and the string is a well formed date" do
      it "presents a date" do
        string = "2023-01-01"

        presenter = described_class.new(string)

        expect(presenter.render).to eq("1 January 2023")
      end
    end

    context "and the string is a well formed time" do
      it "presents a date" do
        string = "2023-01-01T00:00:00+00:00"

        presenter = described_class.new(string)

        expect(presenter.render).to eq("1 January 2023")
      end
    end

    context "and the string is badly formed" do
      it "returns nil" do
        string = "not-a-date"

        presenter = described_class.new(string)

        expect(presenter.render).to be_nil
      end
    end

    context "and the string is an impossible date" do
      it "returns nil" do
        string = "2025-02-30"

        presenter = described_class.new(string)

        expect(presenter.render).to be_nil
      end
    end
  end

  context "when the given param is a Time object (via NormalisedDateRange)" do
    it "presents a date" do
      time = Time.zone.parse("2023-01-01T000:00:00+00:00")

      presenter = described_class.new(time)

      expect(presenter.render).to eq("1 January 2023")
    end
  end

  context "when the param is nil" do
    it "renders nothing" do
      presenter = described_class.new(nil)

      expect(presenter.render).to be_nil
    end
  end
end
