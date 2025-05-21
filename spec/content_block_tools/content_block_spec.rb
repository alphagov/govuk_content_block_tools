RSpec.describe ContentBlockTools::ContentBlock do
  let(:content_id) { SecureRandom.uuid }
  let(:title) { "Some Title" }
  let(:document_type) { "content_block_email_address" }
  let(:details) { { some: "details" } }
  let(:embed_code) { "something" }

  let(:content_block) do
    described_class.new(
      document_type:,
      content_id:,
      title:,
      details:,
      embed_code:,
    )
  end

  it "initializes correctly" do
    expect(content_block.document_type).to eq(document_type)
    expect(content_block.content_id).to eq(content_id)
    expect(content_block.title).to eq(title)
    expect(content_block.details).to eq(details)
  end

  describe ".details" do
    let(:details) do
      {
        "foo" => {
          "bar" => {
            "fizz" => "buzz",
          },
        },
      }
    end

    it "symbolizes the keys" do
      expect(content_block.details).to eq({ foo: { bar: { fizz: "buzz" } } })
    end
  end

  describe ".render" do
    let(:render_response) { "SOME_HTML" }
    let(:presenter_double) { double(presenter_class, render: render_response) }

    before do
      expect(presenter_class).to receive(:new).with(content_block) {
        presenter_double
      }
    end

    context "when an email address" do
      let(:document_type) { "content_block_email_address" }
      let(:presenter_class) { ContentBlockTools::Presenters::EmailAddressPresenter }

      it "calls the email address presenter" do
        expect(content_block.render).to eq(render_response)
        expect(presenter_double).to have_received(:render)
      end
    end

    context "when a contact" do
      let(:document_type) { "content_block_contact" }
      let(:presenter_class) { ContentBlockTools::Presenters::ContactPresenter }

      it "calls the contact presenter" do
        expect(content_block.render).to eq(render_response)
        expect(presenter_double).to have_received(:render)
      end
    end

    context "when presenter can't be found" do
      let(:document_type) { "contact" }
      let(:presenter_class) { ContentBlockTools::Presenters::BasePresenter }

      it "calls the base presenter" do
        expect(content_block.render).to eq(render_response)
        expect(presenter_double).to have_received(:render)
      end
    end
  end

  describe ".field_order" do
    let(:details) do
      {
        "foo" => {
          "bar" => {
            "fizz" => "buzz",
          },
          "baz" => {
            "fizz" => "bazz",
          },
        },
        "something" => {
          "else" => {
            "name" => "something",
          },
        },
        "field_orders" => field_orders,
      }
    end

    context "when a field order is not provided" do
      let(:field_orders) { nil }

      it "returns the keys in a standard order" do
        expect(content_block.field_order).to eq(["title", { foo: %i[bar baz] }, { something: %i[else] }])
      end
    end

    context "when a field order is provided" do
      let(:field_orders) do
        { default: ["title", { something: %i[else] }, { foo: %i[baz bar] }] }
      end

      it "returns the keys in a standard order" do
        expect(content_block.field_order).to eq(field_orders[:default])
      end
    end
  end
end
