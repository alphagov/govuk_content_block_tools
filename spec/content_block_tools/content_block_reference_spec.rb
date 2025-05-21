RSpec.describe ContentBlockTools::ContentBlockReference do
  let(:content_id) { SecureRandom.uuid }
  let(:document_type) { "content_block_pension" }
  let(:embed_code) { "{{embed:content_block_pension:#{SecureRandom.uuid}}}" }

  it "initializes correctly" do
    content_block = described_class.new(
      document_type:,
      identifier: content_id,
      embed_code:,
    )

    expect(content_block.document_type).to eq(document_type)
    expect(content_block.identifier).to eq(content_id)
    expect(content_block.embed_code).to eq(embed_code)
  end

  describe "#identifier_is_alias?" do
    it "returns true when the identifier is an alias" do
      content_block = described_class.new(
        document_type:,
        identifier: "some-alias",
        embed_code:,
      )

      expect(content_block.identifier_is_alias?).to be true
    end

    it "returns false when the identifier is a UUID" do
      content_block = described_class.new(
        document_type:,
        identifier: content_id,
        embed_code:,
      )

      expect(content_block.identifier_is_alias?).to be false
    end
  end

  describe ".find_all_in_document" do
    let(:result) { described_class.find_all_in_document(document) }

    describe "when there is no embedded content" do
      let(:document) { "foo" }

      it "returns an empty array" do
        expect(result).to eq([])
      end
    end

    describe "when there is embedded content with a UUID" do
      let(:contact_uuid) { SecureRandom.uuid }
      let(:content_block_pension_uuid) { SecureRandom.uuid }

      let(:document) do
        "
        {{embed:contact:#{contact_uuid}}}
        {{embed:content_block_pension:#{content_block_pension_uuid}}}
      "
      end

      describe "#content_references" do
        it "returns all references" do
          expect(ContentBlockTools.logger).to receive(:info).with("Found Content Block Reference: [\"{{embed:contact:#{contact_uuid}}}\", \"contact\", \"#{contact_uuid}\", nil]")
          expect(ContentBlockTools.logger).to receive(:info).with("Found Content Block Reference: [\"{{embed:content_block_pension:#{content_block_pension_uuid}}}\", \"content_block_pension\", \"#{content_block_pension_uuid}\", nil]")

          expect(result.count).to eq(2)

          expect(result[0].document_type).to eq("contact")
          expect(result[0].identifier).to eq(contact_uuid)
          expect(result[0].embed_code).to eq("{{embed:contact:#{contact_uuid}}}")

          expect(result[1].document_type).to eq("content_block_pension")
          expect(result[1].identifier).to eq(content_block_pension_uuid)
          expect(result[1].embed_code).to eq("{{embed:content_block_pension:#{content_block_pension_uuid}}}")
        end

        context "with duplicate references" do
          let(:document) do
            "
              {{embed:contact:#{contact_uuid}}}
              {{embed:contact:#{contact_uuid}}}
              {{embed:content_block_pension:#{content_block_pension_uuid}}}
            "
          end

          it "retains the duplicates" do
            expect(result.count).to eq(3)

            expect(result[0].identifier).to eq(contact_uuid)
            expect(result[1].identifier).to eq(contact_uuid)
            expect(result[2].identifier).to eq(content_block_pension_uuid)
          end
        end

        context "when there are fields in the embed code" do
          let(:contact_uuid) { SecureRandom.uuid }
          let(:content_block_pension_uuid) { SecureRandom.uuid }

          let(:document) do
            "
              {{embed:contact:#{contact_uuid}/example-field-1}}
              {{embed:contact:#{contact_uuid}/example-field-2}}
              {{embed:content_block_pension:#{content_block_pension_uuid}/another-field}}
            ".squish
          end

          it "finds all the references" do
            expect(result.count).to eq(3)

            expect(result[0].document_type).to eq("contact")
            expect(result[0].identifier).to eq(contact_uuid)
            expect(result[0].embed_code).to eq("{{embed:contact:#{contact_uuid}/example-field-1}}")

            expect(result[1].document_type).to eq("contact")
            expect(result[1].identifier).to eq(contact_uuid)
            expect(result[1].embed_code).to eq("{{embed:contact:#{contact_uuid}/example-field-2}}")

            expect(result[2].document_type).to eq("content_block_pension")
            expect(result[2].identifier).to eq(content_block_pension_uuid)
            expect(result[2].embed_code).to eq("{{embed:content_block_pension:#{content_block_pension_uuid}/another-field}}")
          end
        end
      end
    end

    describe "when there is embedded content with an alias" do
      let(:contact_alias) { "contact-alias" }
      let(:content_block_pension_alias) { "email-address-alias" }

      let(:document) do
        "
        {{embed:contact:#{contact_alias}}}
        {{embed:content_block_pension:#{content_block_pension_alias}}}
      "
      end

      describe "#content_references" do
        it "returns all references" do
          expect(ContentBlockTools.logger).to receive(:info).with("Found Content Block Reference: [\"{{embed:contact:#{contact_alias}}}\", \"contact\", \"#{contact_alias}\", nil]")
          expect(ContentBlockTools.logger).to receive(:info).with("Found Content Block Reference: [\"{{embed:content_block_pension:#{content_block_pension_alias}}}\", \"content_block_pension\", \"#{content_block_pension_alias}\", nil]")

          expect(result.count).to eq(2)

          expect(result[0].document_type).to eq("contact")
          expect(result[0].identifier).to eq(contact_alias)
          expect(result[0].embed_code).to eq("{{embed:contact:#{contact_alias}}}")

          expect(result[1].document_type).to eq("content_block_pension")
          expect(result[1].identifier).to eq(content_block_pension_alias)
          expect(result[1].embed_code).to eq("{{embed:content_block_pension:#{content_block_pension_alias}}}")
        end

        context "when there are fields in the embed code" do
          let(:contact_alias) { "contact-alias" }
          let(:content_block_pension_alias) { "email-address-alias" }

          let(:document) do
            "
              {{embed:contact:#{contact_alias}/example-field-1}}
              {{embed:contact:#{contact_alias}/example-field-2}}
              {{embed:content_block_pension:#{content_block_pension_alias}/another-field}}
            ".squish
          end

          it "finds all the references" do
            expect(result.count).to eq(3)

            expect(result[0].document_type).to eq("contact")
            expect(result[0].identifier).to eq(contact_alias)
            expect(result[0].embed_code).to eq("{{embed:contact:#{contact_alias}/example-field-1}}")

            expect(result[1].document_type).to eq("contact")
            expect(result[1].identifier).to eq(contact_alias)
            expect(result[1].embed_code).to eq("{{embed:contact:#{contact_alias}/example-field-2}}")

            expect(result[2].document_type).to eq("content_block_pension")
            expect(result[2].identifier).to eq(content_block_pension_alias)
            expect(result[2].embed_code).to eq("{{embed:content_block_pension:#{content_block_pension_alias}/another-field}}")
          end
        end
      end
    end
  end
end
