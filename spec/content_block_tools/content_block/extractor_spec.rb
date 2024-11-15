RSpec.describe ContentBlockTools::ContentBlock::Extractor do
  subject { ContentBlockTools::ContentBlock::Extractor.new(document) }

  describe "when there is no embedded content" do
    let(:document) { "foo" }

    describe "#content_references" do
      it "returns an empty array" do
        expect(subject.content_references).to eq([])
      end
    end

    describe "#content_ids" do
      it "returns an empty array" do
        expect(subject.content_ids).to eq([])
      end
    end
  end

  describe "when there is embedded content" do
    let(:contact_uuid) { SecureRandom.uuid }
    let(:content_block_email_address_uuid) { SecureRandom.uuid }

    let(:document) do
      """
        {{embed:contact:#{contact_uuid}}}
        {{embed:content_block_email_address:#{content_block_email_address_uuid}}}
      """
    end

    describe "#content_references" do
      it "returns all references" do
        result = subject.content_references

        expect(result.count).to eq(2)

        expect(result[0].document_type).to eq("contact")
        expect(result[0].content_id).to eq(contact_uuid)
        expect(result[0].embed_code).to eq("{{embed:contact:#{contact_uuid}}}")

        expect(result[1].document_type).to eq("content_block_email_address")
        expect(result[1].content_id).to eq(content_block_email_address_uuid)
        expect(result[1].embed_code).to eq("{{embed:content_block_email_address:#{content_block_email_address_uuid}}}")
      end
    end

    describe "#content_ids" do
      it "returns all uuids as an array" do
        expect(subject.content_ids).to eq([contact_uuid, content_block_email_address_uuid])
      end
    end
  end
end
