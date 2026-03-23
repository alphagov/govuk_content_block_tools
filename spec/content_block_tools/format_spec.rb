RSpec.describe ContentBlockTools::Format do
  describe "DEFAULT_FORMAT" do
    it "is 'default'" do
      expect(ContentBlockTools::Format::DEFAULT_FORMAT).to eq("default")
    end
  end
end
