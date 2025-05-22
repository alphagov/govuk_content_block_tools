RSpec.describe ContentBlockTools::Renderers::FieldRenderer do
  let(:document_type) { :contact }
  let(:keys_from_embed_code) { %i[email_addresses foo email_address] }
  let(:content) { "hello@example.com" }
  let(:details) do
    {
      email_addresses: {
        foo: {
          email_address: content,
        },
      },
    }
  end

  let(:content_block) do
    double(
      :content_block,
      content_id: "123",
      document_type: document_type,
      keys_from_embed_code:,
      details:,
      embed_code: "<embed-code>",
    )
  end

  subject(:renderer) { described_class.new(content_block) }

  describe "#render" do
    context "when content exists at the embed code path" do
      it "uses the correct presenter and renders the content" do
        presenter_double = instance_double("EmailAddressPresenter", render: "Rendered Content")

        expect(ContentBlockTools::Presenters::FieldPresenters::Contact::EmailAddressPresenter)
          .to receive(:new)
                .with(content)
                .and_return(presenter_double)

        expect(renderer.render).to eq("Rendered Content")
      end

      context "when no presenter exists" do
        let(:details) do
          {
            unknown: {
              foo: {
                email_address: content,
              },
            },
          }
        end
        let(:document_type) { :unknown }
        let(:keys_from_embed_code) { %i[unknown foo email_address] }

        it "falls back to the base presenter" do
          presenter_double = instance_double("BasePresenter", render: "Rendered Content")

          expect(ContentBlockTools::Presenters::FieldPresenters::BasePresenter)
            .to receive(:new)
                  .with(content)
                  .and_return(presenter_double)

          expect(renderer.render).to eq("Rendered Content")
        end
      end
    end

    context "when content is missing" do
      let(:content) { nil }

      it "logs a warning and returns the embed code" do
        expect(ContentBlockTools.logger).to receive(:warn)
                                              .with("Content not found for content block 123 and fields #{keys_from_embed_code}")
        expect(renderer.render).to eq("<embed-code>")
      end
    end
  end
end
