RSpec.describe ContentBlockTools::EmbedCode do
  describe "#field_names" do
    context "when embed code has no field path" do
      let(:embed_code) { "{{embed:content_block_contact:main-office}}" }

      it "returns an empty array" do
        expect(described_class.new(embed_code).field_names).to eq([])
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

  describe "#internal_content_path" do
    it "returns an InternalContentPath with the field names" do
      embed_code = described_class.new("{{embed:content_block_contact:main-office/email_addresses/main}}")
      path = embed_code.internal_content_path

      expect(path).to be_a(ContentBlockTools::InternalContentPath)
      expect(path.path).to eq(%i[email_addresses main])
    end

    it "returns an empty InternalContentPath when no field path" do
      embed_code = described_class.new("{{embed:content_block_contact:main-office}}")
      path = embed_code.internal_content_path

      expect(path).not_to be_present
    end
  end
end
