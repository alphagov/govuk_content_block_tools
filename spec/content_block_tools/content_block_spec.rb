RSpec.describe ContentBlockTools::ContentBlock do
  let(:content_id) { SecureRandom.uuid }
  let(:title) { "Some Title" }
  let(:document_type) { "content_block_email_address" }
  let(:details) { { some: "details" } }

  let(:content_block) do
    described_class.new(
      document_type:,
      content_id:,
      title:,
      details:,
    )
  end

  it "initializes correctly" do
    expect(content_block.document_type).to eq(document_type)
    expect(content_block.content_id).to eq(content_id)
    expect(content_block.title).to eq(title)
    expect(content_block.details).to eq(details)
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

    context "when presenter can't be found" do
      let(:document_type) { "contact" }
      let(:presenter_class) { ContentBlockTools::Presenters::BasePresenter }

      it "calls the base presenter" do
        expect(content_block.render).to eq(render_response)
        expect(presenter_double).to have_received(:render)
      end
    end
  end
end
