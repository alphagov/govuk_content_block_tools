RSpec.describe ContentBlockTools::Format do
  describe "::from_embed_code(embed_code)" do
    context "when the embed code ends with a format demarcated by '*|format_name'" do
      let(:examples) do
        [
          { embed_code: "{{embed:content_block:time_period:tax-year|years_short}}",
            format: "years_short" },

          { embed_code: "{{embed:content_block:time_period:tax-year|years}}",
            format: "years" },

          { embed_code: "{{embed:content_block_contact:main_office/telephones/telephone|hmrc_full}}",
            format: "hmrc_full" },
        ]
      end

      it "returns that format, as found" do
        aggregate_failures do
          examples.each do |example|
            format_derived = ContentBlockTools::Format.from_embed_code(example.fetch(:embed_code))

            expect(format_derived).to eq(
              example.fetch(:format),
            ), "expected '#{example.fetch(:format)}' from embed_code '#{example.fetch(:embed_code)}' " \
              "(received #{format_derived})"
          end
        end
      end
    end

    context "when the embed code does NOT end with a format demarcated by '*|format_name'" do
      let(:examples) do
        %w[
          {{embed:content_block_contact:main_office}}
          {{embed:content_block_contact:main_office/telephones/telephone}}
        ]
      end

      it "returns the DEFAULT_FORMAT" do
        aggregate_failures do
          examples.each do |embed_code|
            format_derived = ContentBlockTools::Format.from_embed_code(embed_code)

            expect(format_derived).to eq(
              ContentBlockTools::Format::DEFAULT_FORMAT,
            ), "expected 'default' format from embed_code '#{embed_code}' (received #{format_derived})"
          end
        end
      end
    end
  end
end
