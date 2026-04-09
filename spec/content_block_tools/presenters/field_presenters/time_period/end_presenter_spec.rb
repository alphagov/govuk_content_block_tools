RSpec.describe ContentBlockTools::Presenters::FieldPresenters::TimePeriod::EndPresenter do
  around do |example|
    Time.use_zone("London") { example.run }
  end

  it "presents an end datetime as a formatted date" do
    datetime = "2026-04-05T23:59:00+01:00"

    presenter = described_class.new(datetime)

    expect(presenter.render).to eq("5 April 2026")
  end

  it "handles datetimes with different timezones" do
    datetime = "2023-12-31T23:59:59+00:00"

    presenter = described_class.new(datetime)

    expect(presenter.render).to eq("31 December 2023")
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
