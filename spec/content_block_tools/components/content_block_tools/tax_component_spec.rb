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
              {
                name: "Basic rate",
                value: "20%",
                bands: [
                  {
                    name: "Basic rate",
                    lower_threshold: { show: true, value: "£12,571" },
                    upper_threshold: { show: true, value: "£50,270" },
                  },
                ],
              },
            ],
          },
        },
      }
    end

    describe "rendering with tax_table format" do
      let(:embed_code) { "{{embed:content_block_tax:income-tax#tax_table}}" }

      it "renders a table" do
        expect(component.render).to have_tag("table", with: { class: "govuk-table" })
      end

      it "renders table headers" do
        rendered = component.render
        expect(rendered).to have_tag("th", text: "Band")
        expect(rendered).to have_tag("th", text: "Taxable income")
        expect(rendered).to have_tag("th", text: "Tax rate")
      end

      it "renders the income tax rates as rows" do
        rendered = component.render
        expect(rendered).to have_tag("td", text: "Personal Allowance")
        expect(rendered).to have_tag("td", text: "Up to £12,570")
        expect(rendered).to have_tag("td", text: "0%")
      end
    end

    describe "format validation" do
      context "with tax_table format" do
        let(:embed_code) { "{{embed:content_block_tax:income-tax#tax_table}}" }

        it "does not raise an error" do
          expect { component }.not_to raise_error
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

    describe "data validation for tax_table" do
      let(:embed_code) { "{{embed:content_block_tax:income-tax#tax_table}}" }

      context "when things_taxed is missing" do
        let(:details) { { tax_type: "Tax" } }

        it "raises InvalidFormatError with descriptive message" do
          expect { component }.to raise_error(
            ContentBlockTools::InvalidFormatError,
            "Cannot render 'tax_table' format: missing income tax rates",
          )
        end
      end

      context "when income is missing from things_taxed" do
        let(:details) { { tax_type: "Tax", things_taxed: {} } }

        it "raises InvalidFormatError with descriptive message" do
          expect { component }.to raise_error(
            ContentBlockTools::InvalidFormatError,
            "Cannot render 'tax_table' format: missing income tax rates",
          )
        end
      end

      context "when rates is missing from income" do
        let(:details) { { tax_type: "Tax", things_taxed: { income: { title: "Income" } } } }

        it "raises InvalidFormatError with descriptive message" do
          expect { component }.to raise_error(
            ContentBlockTools::InvalidFormatError,
            "Cannot render 'tax_table' format: missing income tax rates",
          )
        end
      end

      context "when rates is empty" do
        let(:details) { { tax_type: "Tax", things_taxed: { income: { rates: [] } } } }

        it "raises InvalidFormatError with descriptive message" do
          expect { component }.to raise_error(
            ContentBlockTools::InvalidFormatError,
            "Cannot render 'tax_table' format: missing income tax rates",
          )
        end
      end
    end
  end
end
