RSpec.describe ContentBlockTools::Presenters::FieldPresenters::BasePresenter do
  it "presents a value" do
    field = "Some text"

    presenter = described_class.new(field)

    expect(presenter.render).to eq(field)
  end
end
