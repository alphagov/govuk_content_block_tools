RSpec.describe ContentBlockTools::PensionComponent do
  describe "#render" do
    let(:content_id) { SecureRandom.uuid }
    let(:embed_code) { "{{embed:content_block_pension:state-pension}}" }

    let(:content_block) do
      ContentBlockTools::ContentBlock.new(
        document_type: "content_block_pension",
        content_id:,
        title: "State Pension",
        details: details,
        embed_code: embed_code,
      )
    end

    let(:component) { described_class.new(content_block:) }

    let(:details) do
      {
        rates: {
          "weekly-rate": {
            title: "Weekly rate",
            amount: "£241.30",
            frequency: "a week",
          },
        },
      }
    end

    describe "format validation" do
      context "with default format" do
        let(:embed_code) { "{{embed:content_block_pension:state-pension}}" }

        it "does not raise an error" do
          expect { component }.not_to raise_error
        end

        it "returns an empty string" do
          expect(component.render).to eq("")
        end
      end

      context "with explicit default format" do
        let(:embed_code) { "{{embed:content_block_pension:state-pension#default}}" }

        it "does not raise an error" do
          expect { component }.not_to raise_error
        end
      end

      context "with one_off_arrears format" do
        let(:embed_code) { "{{embed:content_block_pension:state-pension#one_off_arrears}}" }

        it "does not raise an error" do
          expect { component }.not_to raise_error
        end
      end

      context "with an unsupported format" do
        let(:embed_code) { "{{embed:content_block_pension:state-pension#unknown_format}}" }

        it "raises InvalidFormatError" do
          expect { component }.to raise_error(
            ContentBlockTools::InvalidFormatError,
            "Unknown format 'unknown_format' for pension",
          )
        end
      end
    end

    describe "rate validation for one_off_arrears" do
      let(:embed_code) { "{{embed:content_block_pension:state-pension#one_off_arrears}}" }

      context "when there is exactly one rate" do
        it "does not raise an error" do
          expect { component }.not_to raise_error
        end
      end

      context "when there is no rates key" do
        let(:details) { {} }

        it "raises InvalidFormatError" do
          expect { component }.to raise_error(
            ContentBlockTools::InvalidFormatError,
            "Cannot render 'one_off_arrears' format: no rates found",
          )
        end
      end

      context "when the rates collection is empty" do
        let(:details) { { rates: {} } }

        it "raises InvalidFormatError" do
          expect { component }.to raise_error(
            ContentBlockTools::InvalidFormatError,
            "Cannot render 'one_off_arrears' format: no rates found",
          )
        end
      end

      context "when there are multiple rates" do
        let(:details) do
          {
            rates: {
              "rate-one": { title: "Rate one", amount: "£100.00" },
              "rate-two": { title: "Rate two", amount: "£200.00" },
            },
          }
        end

        it "raises InvalidFormatError" do
          expect { component }.to raise_error(
            ContentBlockTools::InvalidFormatError,
            "Cannot render 'one_off_arrears' format: expected exactly one rate, found 2",
          )
        end
      end
    end
  end
end
