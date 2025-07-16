RSpec.describe ContentBlockTools::Govspeak do
  include ContentBlockTools::Govspeak

  describe "#render_govspeak" do
    let(:govspeak) { "Some govspeak **here**" }

    context "when a root_class is not provided" do
      it "renders Govspeak" do
        expect(render_govspeak(govspeak)).to eq("<p>Some govspeak <strong>here</strong></p>\n")
      end
    end

    context "when a root_class is provided" do
      it "renders Govspeak with a root class" do
        expect(render_govspeak(govspeak, root_class: "foo")).to eq("<p class=\"foo\">Some govspeak <strong>here</strong></p>\n")
      end
    end
  end
end
