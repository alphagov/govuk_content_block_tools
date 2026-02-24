RSpec.describe ContentBlockTools::Presenters::FieldPresenters::TimePeriod::TimePresenter do
  it "presents a time with hours and minutes" do
    time = "13:15"

    time = described_class.new(time)

    expect(time.render).to eq("1:15pm")
  end

  it "presents a time without minutes" do
    time = "13:00"

    time = described_class.new(time)

    expect(time.render).to eq("1pm")
  end

  it "returns 00:00 as `midnight`" do
    time = "00:00"

    time = described_class.new(time)

    expect(time.render).to eq("midnight")
  end

  it "returns 12:00 as `midday`" do
    time = "12:00"

    time = described_class.new(time)

    expect(time.render).to eq("midday")
  end
end
