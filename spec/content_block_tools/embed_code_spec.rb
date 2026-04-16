RSpec.describe ContentBlockTools::EmbedCode do
  describe "#internal_content_path" do
    subject(:path) { described_class.new(embed_code).internal_content_path }

    context "when embed code has no field path" do
      let(:embed_code) { "{{embed:content_block_contact:main-office}}" }

      it "returns an empty path" do
        expect(path.path).to eq([])
      end

      it "is not present" do
        expect(path).not_to be_present
      end
    end

    context "when embed code has a single field" do
      let(:embed_code) { "{{embed:content_block_contact:main-office/email}}" }

      it "returns the field as a symbol" do
        expect(path.path).to eq([:email])
      end

      it "is singular" do
        expect(path).to be_singular
      end
    end

    context "when embed code has multiple fields" do
      let(:embed_code) { "{{embed:content_block_contact:main-office/email_addresses/main}}" }

      it "returns all fields as symbols" do
        expect(path.path).to eq(%i[email_addresses main])
      end

      it "exposes block_type and block_name" do
        expect(path.block_type).to eq(:email_addresses)
        expect(path.block_name).to eq(:main)
      end
    end

    context "when embed code has numeric segments" do
      let(:embed_code) { "{{embed:content_block_contact:main-office/email_addresses/0/email}}" }

      it "converts numeric segments to integers" do
        expect(path.path).to eq([:email_addresses, 0, :email])
      end
    end

    context "when embed code is invalid" do
      let(:embed_code) { "invalid" }

      it "returns an empty path" do
        expect(path.path).to be_empty
      end
    end
  end
end
