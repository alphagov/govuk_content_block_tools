RSpec.describe ContentBlockTools::Presenters::FieldPresenters::TimePeriod::DatePresenter do
  it "presents a date" do
    date = "2023-01-01"

    presenter = described_class.new(date)

    expect(presenter.render).to eq("1 January 2023")
  end

  context "when the date is not defined" do
    it "renders nothing" do
      presenter = described_class.new(nil)

      expect(presenter.render).to be_nil
    end
  end
end
