RSpec.describe ContentBlockTools::Pension::OneOffArrearsComponent do
  describe "#render" do
    let(:component) { described_class.new(amount:) }
    let(:amount) { BigDecimal("241.30") }
    let(:html) { Capybara.string(component.render) }

    it "renders a containing div" do
      expect(html).to have_css("div")
    end

    it "renders two paragraphs" do
      expect(html).to have_css("div > p", count: 2)
    end

    describe "first paragraph (52 weeks deferral)" do
      let(:first_paragraph) { html.first("p") }

      it "mentions 52 weeks deferral" do
        expect(first_paragraph).to have_text("for 52 weeks")
      end

      it "calculates arrears correctly (£241.30 × 52 = £12,547.60)" do
        expect(first_paragraph).to have_text("one-off arrears payment of £12,547.60")
      end

      it "includes a link to the new state pension page" do
        expect(first_paragraph).to have_css(
          "a[href='/new-state-pension']",
          text: "full new State Pension",
        )
      end
    end

    describe "second paragraph (27 weeks deferral)" do
      let(:second_paragraph) { html.all("p").last }

      it "mentions 27 weeks deferral" do
        expect(second_paragraph).to have_text("for 27 weeks")
      end

      it "calculates arrears correctly (£241.30 × 27 = £6,515.10)" do
        expect(second_paragraph).to have_text("one-off arrears payment of £6,515.10")
      end

      it "includes a link to the new state pension page" do
        expect(second_paragraph).to have_css(
          "a[href='/new-state-pension']",
          text: "full new State Pension",
        )
      end
    end

    describe "currency formatting" do
      context "with an amount requiring thousand separators" do
        let(:amount) { BigDecimal("1000.00") }

        it "formats 52-week arrears with commas (£1000 × 52 = £52,000.00)" do
          expect(html.first("p")).to have_text("£52,000.00")
        end

        it "formats 27-week arrears with commas (£1000 × 27 = £27,000.00)" do
          expect(html.all("p").last).to have_text("£27,000.00")
        end
      end

      context "with a small amount" do
        let(:amount) { BigDecimal("10.00") }

        it "formats without thousand separators" do
          expect(html.first("p")).to have_text("£520.00")
          expect(html.all("p").last).to have_text("£270.00")
        end
      end

      context "with a precise decimal amount" do
        let(:amount) { BigDecimal("100.50") }

        it "maintains two decimal places" do
          expect(html.first("p")).to have_text("£5,226.00")
          expect(html.all("p").last).to have_text("£2,713.50")
        end
      end
    end
  end
end
