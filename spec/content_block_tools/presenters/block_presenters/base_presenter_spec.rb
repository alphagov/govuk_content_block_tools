RSpec.describe ContentBlockTools::Presenters::BlockPresenters::BasePresenter do
  let(:item) do
    {
      "title": "Something",
      "field1": "Field 1",
      "field2": "Field 2",
    }
  end

  it "should render successfully" do
    presenter = described_class.new(item)

    expect(presenter.render).to have_tag("div") do
      with_tag("p", text: "Something")
      with_tag("p", text: "Field 1")
      with_tag("p", text: "Field 2")
    end
  end
end
