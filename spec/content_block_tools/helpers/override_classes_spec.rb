RSpec.describe ContentBlockTools::OverrideClasses do
  let(:test_class) do
    Class.new do
      include ContentBlockTools::OverrideClasses
    end
  end

  let(:test_instance) { test_class.new }

  describe "#margin_classes" do
    context "when only top value is provided" do
      it "returns a uniform margin class" do
        expect(test_instance.margin_classes(4)).to eq("govuk-!-margin-4")
      end
    end

    context "when all four values are provided" do
      it "returns individual margin classes for each side" do
        result = test_instance.margin_classes(4, 3, 2, 1)
        expect(result).to eq("govuk-!-margin-top-4 govuk-!-margin-right-3 govuk-!-margin-bottom-2 govuk-!-margin-left-1")
      end
    end
  end

  describe "#padding_classes" do
    context "when only top value is provided" do
      it "returns a uniform padding class" do
        expect(test_instance.padding_classes(5)).to eq("govuk-!-padding-5")
      end
    end

    context "when all four values are provided" do
      it "returns individual padding classes for each side" do
        result = test_instance.padding_classes(8, 6, 4, 2)
        expect(result).to eq("govuk-!-padding-top-8 govuk-!-padding-right-6 govuk-!-padding-bottom-4 govuk-!-padding-left-2")
      end
    end
  end

  describe "#font_classes" do
    it "returns the correct font classes" do
      expect(test_instance.font_classes(16, "bold")).to eq("govuk-!-font-size-16 govuk-!-font-weight-bold")
    end
  end

  describe "#font_size_class" do
    it "returns the correct font size class for integer values" do
      expect(test_instance.font_size_class(16)).to eq("govuk-!-font-size-16")
      expect(test_instance.font_size_class(19)).to eq("govuk-!-font-size-19")
      expect(test_instance.font_size_class(24)).to eq("govuk-!-font-size-24")
      expect(test_instance.font_size_class(27)).to eq("govuk-!-font-size-27")
      expect(test_instance.font_size_class(48)).to eq("govuk-!-font-size-48")
      expect(test_instance.font_size_class(80)).to eq("govuk-!-font-size-80")
    end
  end

  describe "#font_weight_class" do
    it "returns the correct font weight class for bold" do
      expect(test_instance.font_weight_class("bold")).to eq("govuk-!-font-weight-bold")
    end

    it "returns the correct font weight class for regular" do
      expect(test_instance.font_weight_class("regular")).to eq("govuk-!-font-weight-regular")
    end
  end
end
