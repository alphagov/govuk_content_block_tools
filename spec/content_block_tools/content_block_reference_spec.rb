RSpec.describe ContentBlockTools::ContentBlockReference do
  it "initializes correctly" do
    content_id = SecureRandom.uuid
    document_type = "content_block_email_address"
    embed_code = "{{embed:content_block_email_address:#{SecureRandom.uuid}}}"

    content_block = described_class.new(
      document_type:,
      content_id:,
      embed_code:,
    )

    expect(content_block.document_type).to eq(document_type)
    expect(content_block.content_id).to eq(content_id)
    expect(content_block.embed_code).to eq(embed_code)
  end

  describe ".find_all_in_document" do
    let(:result) { described_class.find_all_in_document(document) }

    describe "when there is no embedded content" do
      let(:document) { "foo" }

      it "returns an empty array" do
        expect(result).to eq([])
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
          expect(result.count).to eq(2)

          expect(result[0].document_type).to eq("contact")
          expect(result[0].content_id).to eq(contact_uuid)
          expect(result[0].embed_code).to eq("{{embed:contact:#{contact_uuid}}}")

          expect(result[1].document_type).to eq("content_block_email_address")
          expect(result[1].content_id).to eq(content_block_email_address_uuid)
          expect(result[1].embed_code).to eq("{{embed:content_block_email_address:#{content_block_email_address_uuid}}}")
        end

        context "with duplicate references" do
          let(:document) do
            """
              {{embed:contact:#{contact_uuid}}}
              {{embed:contact:#{contact_uuid}}}
              {{embed:content_block_email_address:#{content_block_email_address_uuid}}}
            """
          end

          it "retains the duplicates" do
            expect(result.count).to eq(3)

            expect(result[0].content_id).to eq(contact_uuid)
            expect(result[1].content_id).to eq(contact_uuid)
            expect(result[2].content_id).to eq(content_block_email_address_uuid)
          end
        end
      end
    end
  end
end
