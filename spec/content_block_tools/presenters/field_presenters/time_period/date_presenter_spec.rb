RSpec.describe ContentBlockTools::Presenters::FieldPresenters::TimePeriod::DatePresenter do
  it "presents a date" do
    date = "2023-01-01"

    presenter = described_class.new(date)

    expect(presenter.render).to eq("1 January 2023")
  end
end
