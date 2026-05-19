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

    describe "amount validation for one_off_arrears" do
      let(:embed_code) { "{{embed:content_block_pension:state-pension#one_off_arrears}}" }

      context "with a valid amount" do
        it "does not raise an error" do
          expect { component }.not_to raise_error
        end
      end

      context "with amount without currency symbol" do
        let(:details) { { rates: { "rate": { amount: "241.30" } } } }

        it "does not raise an error" do
          expect { component }.not_to raise_error
        end
      end

      context "with amount with commas" do
        let(:details) { { rates: { "rate": { amount: "£1,241.30" } } } }

        it "does not raise an error" do
          expect { component }.not_to raise_error
        end
      end

      context "with missing amount" do
        let(:details) { { rates: { "rate": { title: "Rate" } } } }

        it "raises InvalidFormatError" do
          expect { component }.to raise_error(
            ContentBlockTools::InvalidFormatError,
            "Cannot render 'one_off_arrears' format: rate is missing 'amount'",
          )
        end
      end

      context "with empty amount" do
        let(:details) { { rates: { "rate": { amount: "" } } } }

        it "raises InvalidFormatError" do
          expect { component }.to raise_error(
            ContentBlockTools::InvalidFormatError,
            "Cannot render 'one_off_arrears' format: rate is missing 'amount'",
          )
        end
      end

      context "with whitespace-only amount" do
        let(:details) { { rates: { "rate": { amount: "   " } } } }

        it "raises InvalidFormatError" do
          expect { component }.to raise_error(
            ContentBlockTools::InvalidFormatError,
            "Cannot render 'one_off_arrears' format: rate is missing 'amount'",
          )
        end
      end

      context "with invalid amount format" do
        let(:details) { { rates: { "rate": { amount: "not a number" } } } }

        it "raises InvalidFormatError" do
          expect { component }.to raise_error(
            ContentBlockTools::InvalidFormatError,
            "Cannot render 'one_off_arrears' format: 'not a number' is not a valid currency amount",
          )
        end
      end

      context "with zero amount" do
        let(:details) { { rates: { "rate": { amount: "£0.00" } } } }

        it "raises InvalidFormatError" do
          expect { component }.to raise_error(
            ContentBlockTools::InvalidFormatError,
            "Cannot render 'one_off_arrears' format: amount must be positive",
          )
        end
      end

      context "with negative amount" do
        let(:details) { { rates: { "rate": { amount: "-£100.00" } } } }

        it "raises InvalidFormatError" do
          expect { component }.to raise_error(
            ContentBlockTools::InvalidFormatError,
            "Cannot render 'one_off_arrears' format: '-£100.00' is not a valid currency amount",
          )
        end
      end
    end

    describe "rendering one_off_arrears format" do
      let(:embed_code) { "{{embed:content_block_pension:state-pension#one_off_arrears}}" }

      it "renders arrears paragraphs via OneOffArrearsComponent" do
        rendered = component.render
        expect(rendered).to include("one-off arrears payment of £12,547.60")
        expect(rendered).to include("one-off arrears payment of £6,515.10")
      end

      it "includes a link to /new-state-pension" do
        expect(component.render).to have_tag("a", with: { href: "/new-state-pension" })
      end

      it "renders within a div" do
        expect(component.render).to have_tag("div") do
          with_tag("p", count: 2)
        end
      end
    end
  end
end
