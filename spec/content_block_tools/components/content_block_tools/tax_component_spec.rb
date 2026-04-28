RSpec.describe ContentBlockTools::TaxComponent do
  describe "#render" do
    let(:content_id) { SecureRandom.uuid }
    let(:embed_code) { "{{embed:content_block_tax:income-tax#tax_table}}" }

    let(:content_block) do
      ContentBlockTools::ContentBlock.new(
        document_type: "content_block_tax",
        content_id:,
        title: "Income Tax",
        details: details,
        embed_code: embed_code,
      )
    end

    let(:component) { described_class.new(content_block:) }

    let(:details) do
      {
        tax_type: "Tax",
        things_taxed: {
          income: {
            title: "Income",
            type: "Income",
            rates: [
              {
                name: "Zero rate",
                value: "0%",
                bands: [
                  {
                    name: "Personal Allowance",
                    lower_threshold: { show: true, value: "£0" },
                    upper_threshold: { show: true, value: "£12,570" },
                  },
                ],
              },
            ],
          },
        },
      }
    end

    describe "format validation" do
      context "with tax_table format" do
        let(:embed_code) { "{{embed:content_block_tax:income-tax#tax_table}}" }

        it "does not raise an error" do
          expect { component }.not_to raise_error
        end

        it "returns a string from render" do
          expect(component.render).to be_a(String)
        end
      end

      context "with default format" do
        let(:embed_code) { "{{embed:content_block_tax:income-tax#default}}" }

        it "does not raise an error" do
          expect { component }.not_to raise_error
        end
      end

      context "with no format specified" do
        let(:embed_code) { "{{embed:content_block_tax:income-tax}}" }

        it "does not raise an error" do
          expect { component }.not_to raise_error
        end
      end

      context "with an unsupported format" do
        let(:embed_code) { "{{embed:content_block_tax:income-tax#unknown_format}}" }

        it "raises InvalidFormatError" do
          expect { component }.to raise_error(
            ContentBlockTools::InvalidFormatError,
            "Unknown format 'unknown_format' for tax",
          )
        end
      end
    end
  end
end
