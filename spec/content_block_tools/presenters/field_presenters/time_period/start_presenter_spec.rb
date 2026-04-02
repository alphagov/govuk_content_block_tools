RSpec.describe ContentBlockTools::Presenters::FieldPresenters::TimePeriod::StartPresenter do
  around do |example|
    Time.use_zone("London") { example.run }
  end

  it "presents a start datetime as a formatted date" do
    datetime = "2025-04-06T00:00:00+01:00"

    presenter = described_class.new(datetime)

    expect(presenter.render).to eq("6 April 2025")
  end

  it "handles datetimes with different timezones" do
    datetime = "2023-12-25T14:30:00+00:00"

    presenter = described_class.new(datetime)

    expect(presenter.render).to eq("25 December 2023")
  end

  context "when the datetime is not defined" do
    it "renders nothing" do
      presenter = described_class.new(nil)

      expect(presenter.render).to be_nil
    end
  end

  context "when the datetime is blank" do
    it "renders nothing" do
      presenter = described_class.new("")

      expect(presenter.render).to be_nil
    end
  end
end
