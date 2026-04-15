RSpec.describe ContentBlockTools::EmbedCode do
  describe "#field_names" do
    context "when embed code has no field path" do
      let(:embed_code) { "{{embed:content_block_contact:main-office}}" }

      it "returns nil" do
        expect(described_class.new(embed_code).field_names).to be_nil
      end
    end

    context "when embed code has a single field" do
      let(:embed_code) { "{{embed:content_block_contact:main-office/email}}" }

      it "returns the field as a symbol" do
        expect(described_class.new(embed_code).field_names).to eq([:email])
      end
    end

    context "when embed code has multiple fields" do
      let(:embed_code) { "{{embed:content_block_contact:main-office/email_addresses/main}}" }

      it "returns all fields as symbols" do
        expect(described_class.new(embed_code).field_names).to eq(%i[email_addresses main])
      end
    end

    context "when embed code has numeric segments" do
      let(:embed_code) { "{{embed:content_block_contact:main-office/email_addresses/0/email}}" }

      it "converts numeric segments to integers" do
        expect(described_class.new(embed_code).field_names).to eq([:email_addresses, 0, :email])
      end
    end

    context "when embed code is invalid" do
      let(:embed_code) { "invalid" }

      it "returns an empty list" do
        expect(described_class.new(embed_code).field_names).to be_empty
      end
    end
  end

  describe "#format" do
    context "when no format is specified" do
      let(:embed_code) { "{{embed:content_block_time_period:tax-year}}" }

      it "returns the default format" do
        expect(described_class.new(embed_code).format)
          .to eq(ContentBlockTools::Format::DEFAULT_FORMAT)
      end
    end

    context "when a format is specified" do
      let(:embed_code) { "{{embed:content_block_time_period:tax-year|years_short}}" }

      it "returns the format" do
        expect(described_class.new(embed_code).format).to eq("years_short")
      end
    end

    context "when embed code has fields and a format" do
      let(:embed_code) { "{{embed:content_block_contact:main-office/email|custom_format}}" }

      it "returns the format" do
        expect(described_class.new(embed_code).format).to eq("custom_format")
      end
    end

    context "when embed code is invalid" do
      let(:embed_code) { "invalid" }

      it "returns the default format" do
        expect(described_class.new(embed_code).format)
          .to eq(ContentBlockTools::Format::DEFAULT_FORMAT)
      end
    end
  end
end
