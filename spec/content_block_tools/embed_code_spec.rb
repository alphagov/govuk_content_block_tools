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
end
