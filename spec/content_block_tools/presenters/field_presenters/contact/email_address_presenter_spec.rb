RSpec.describe ContentBlockTools::Presenters::FieldPresenters::Contact::EmailAddressPresenter do
  it "presents an email address" do
    email_address = "foo@example.com"

    presenter = described_class.new(email_address)

    expect(presenter.render).to have_tag(
      :a,
      text: email_address,
      with: { href: "mailto:#{email_address}", class: "govuk-link" },
    )
  end
end
