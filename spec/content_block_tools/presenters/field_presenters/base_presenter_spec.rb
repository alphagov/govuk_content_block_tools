RSpec.describe ContentBlockTools::Presenters::FieldPresenters::BasePresenter do
  it "presents a field" do
    field = "Field"

    presenter = described_class.new(field)

    expect(presenter.render).to have_tag(
      :p,
      text: field,
      with: { class: "govuk-body" },
    )
  end
end
