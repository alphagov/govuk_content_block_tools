RSpec.describe ContentBlockTools::Renderers::BlockRenderer do
  let(:title) { "My Title" }
  let(:email) do
    {
      "title": "Email",
      "email_address": "hello@example.com",
      "description": "General enquiries",
    }
  end
  let(:thing) do
    {
      "key": "Foo",
      "value": "Bar",
    }
  end
  let(:description) { "Description goes here" }

  let(:field_order) do
    [
      "title",
      { things: %w[thing1] },
      { email_addresses: %w[email] },
      "description",
    ]
  end
  let(:details) do
    {
      "description": description,
      "email_addresses": {
        "email": email,
      },
      "things": {
        "thing1": thing,
      },
    }
  end

  let(:content_block) do
    double(
      :content_block,
      title: title,
      field_order: field_order,
      details: details,
      document_type: "content_block_contact",
    )
  end

  subject(:renderer) { described_class.new(content_block) }

  describe "#render" do
    it "concatenates all rendered fields" do
      title_field_double = instance_double("BasePresenter", render: "<h1>Title</h1>")
      base_field_double = instance_double("BasePresenter", render: description)
      base_double = instance_double("BasePresenter", render: "John Doe")
      email_double = instance_double("EmailPresenter", render: "John Doe@example.com")

      expect(ContentBlockTools::Presenters::FieldPresenters::BasePresenter)
        .to receive(:new)
              .with(title)
              .and_return(title_field_double)

      expect(ContentBlockTools::Presenters::FieldPresenters::BasePresenter)
        .to receive(:new)
              .with(description)
              .and_return(base_field_double)

      expect(ContentBlockTools::Presenters::BlockPresenters::Contact::EmailAddressPresenter)
        .to receive(:new)
              .with(email)
              .and_return(email_double)

      expect(ContentBlockTools::Presenters::BlockPresenters::BasePresenter)
        .to receive(:new)
              .with(thing)
              .and_return(base_double)

      expected_output = [
        title_field_double.render,
        base_double.render,
        email_double.render,
        base_field_double.render,
      ].join.html_safe

      expect(renderer.render).to eq(expected_output)
    end
  end
end
