# frozen_string_literal: true

RSpec.describe ContentBlockTools::EmbedCode do
  describe "#field_names" do
    context "when embed code has no field path" do
      it "returns nil" do
        embed_code = described_class.new("{{embed:content_block_contact:my-contact}}")
        expect(embed_code.field_names).to be_nil
      end
    end

    context "when embed code has a single field" do
      it "returns an array with that field as a symbol" do
        embed_code = described_class.new("{{embed:content_block_contact:my-contact/email}}")
        expect(embed_code.field_names).to eq([:email])
      end
    end

    context "when embed code has multiple fields" do
      it "returns an array of symbols" do
        embed_code = described_class.new(
          "{{embed:content_block_contact:my-contact/email_addresses/primary/email}}",
        )
        expect(embed_code.field_names).to eq(%i[email_addresses primary email])
      end
    end

    context "when embed code has numeric field (array index)" do
      it "returns integers for numeric fields" do
        embed_code = described_class.new(
          "{{embed:content_block_contact:my-contact/email_addresses/0/email}}",
        )
        expect(embed_code.field_names).to eq([:email_addresses, 0, :email])
      end
    end

    context "when embed code has a trailing slash" do
      it "ignores the trailing slash" do
        embed_code = described_class.new(
          "{{embed:content_block_time_period:tax-year/date_range/}}",
        )
        expect(embed_code.field_names).to eq([:date_range])
      end
    end

    context "when embed code has a format specifier" do
      it "still parses field names correctly (format is not part of field path)" do
        # NOTE: The current EMBED_REGEX doesn't account for format specifier,
        # so field_names may include the format. This test documents current behaviour.
        embed_code = described_class.new(
          "{{embed:content_block_time_period:tax-year|years_short}}",
        )
        expect(embed_code.field_names).to be_nil
      end
    end

    context "when embed code is invalid" do
      it "returns nil for non-matching embed codes" do
        embed_code = described_class.new("not an embed code")
        expect(embed_code.field_names).to be_nil
      end
    end

    context "when embed code uses UUID identifier" do
      it "parses field names correctly" do
        uuid = "2b92cade-549c-4449-9796-e7a3957f3a86"
        embed_code = described_class.new(
          "{{embed:content_block_pension:#{uuid}/rates/basic}}",
        )
        expect(embed_code.field_names).to eq(%i[rates basic])
      end
    end
  end
end
