RSpec.describe ContentBlockTools::InternalContentPath do
  describe "#path" do
    it "returns the path array" do
      path = described_class.new(%i[email_addresses main])
      expect(path.path).to eq(%i[email_addresses main])
    end
  end

  describe "#present?" do
    let(:path) { described_class.new([:email_addresses]) }

    context "when path has segments" do
      it "returns true" do
        expect(path).to be_present
      end
    end

    context "when path is empty" do
      let(:path) { described_class.new([]) }

      it "returns false" do
        path = described_class.new([])
        expect(path).not_to be_present
      end
    end
  end

  describe "#singular?" do
    context "when path has one segment" do
      let(:path) { described_class.new([:date_range]) }

      it "returns true" do
        expect(path).to be_singular
      end
    end

    context "when path has multiple segments" do
      let(:path) { described_class.new(%i[email_addresses main]) }

      it "returns false" do
        expect(path).not_to be_singular
      end
    end

    context "when path is empty" do
      let(:path) { described_class.new([]) }

      it "returns false" do
        expect(path).not_to be_singular
      end
    end
  end

  describe "#block_type" do
    context "when path has segments" do
      let(:path) { described_class.new(%i[email_addresses main]) }

      it "returns the first segment" do
        expect(path.block_type).to eq(:email_addresses)
      end
    end

    context "when path is empty" do
      let(:path) { described_class.new([]) }

      it "returns nil" do
        expect(path.block_type).to be_nil
      end
    end
  end

  describe "#block_name" do
    context "when path has multiple segments" do
      let(:path) { described_class.new(%i[email_addresses main]) }

      it "returns the last segment" do
        expect(path.block_name).to eq(:main)
      end
    end

    context "when path has one segment" do
      let(:path) { described_class.new([:date_range]) }

      it "returns that segment" do
        expect(path.block_name).to eq(:date_range)
      end
    end

    context "when path is empty" do
      let(:path) { described_class.new([]) }

      it "returns nil" do
        expect(path.block_name).to be_nil
      end
    end
  end
end
