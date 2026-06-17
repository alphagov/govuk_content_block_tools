RSpec.describe ContentBlockTools::Presenters::FieldPresenters::Pension::AmountPresenter do
  context "when the given param is a string representation of a pension rate without a £ prefix" do
    it "presents the rate with a £ prefix" do
      presenter = described_class.new("100.30")

      expect(presenter.render).to eq("£100.30")
    end
  end
end
