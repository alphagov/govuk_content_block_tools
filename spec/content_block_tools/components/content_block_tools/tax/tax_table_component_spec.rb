RSpec.describe ContentBlockTools::Tax::TaxTableComponent do
  let(:rates) do
    [
      {
        name: "Zero rate",
        value: "0%",
        bands: [
          {
            name: "Personal Allowance",
            lower_threshold: { value: "£0" },
            upper_threshold: { value: "£12,570" },
          },
        ],
      },
      {
        name: "Basic rate",
        value: "20%",
        bands: [
          {
            name: "Basic rate",
            lower_threshold: { value: "£12,571" },
            upper_threshold: { value: "£50,270" },
          },
        ],
      },
      {
        name: "Higher rate",
        value: "40%",
        bands: [
          {
            name: "Higher rate",
            lower_threshold: { value: "£50,271" },
            upper_threshold: { value: "£125,140" },
          },
        ],
      },
      {
        name: "Additional rate",
        value: "45%",
        bands: [
          {
            name: "Additional rate",
            lower_threshold: { value: "£125,140" },
          },
        ],
      },
    ]
  end

  let(:component) { described_class.new(rates:) }

  describe "#render" do
    let(:html) { Capybara.string(component.render) }

    it "renders using the govuk_publishing_components table" do
      expect(html).to have_css("table.govuk-table")
    end

    context "header row" do
      let(:header_row) { html.first("thead tr") }

      it "renders table headers" do
        expect(header_row).to have_css("th", text: "Band")
        expect(header_row).to have_css("th", text: "Taxable income")
        expect(header_row).to have_css("th", text: "Tax rate")
      end
    end

    it "renders the expected number of tax band rows" do
      expect(html).to have_css("tbody tr", count: 4)
    end

    describe "first (personal allowance) row (with upper threshold only)" do
      let(:first_row) { html.first("tbody tr") }

      it "renders the band name" do
        expect(first_row).to have_css("td", text: "Personal Allowance")
      end

      it "renders 'Up to' with upper threshold" do
        expect(first_row).to have_css("td", text: "Up to £12,570")
      end

      it "renders the tax rate" do
        expect(first_row).to have_css("td", text: "0%")
      end
    end

    describe "middle rows (with both thresholds)" do
      let(:basic_rate_row) { html.all("tbody tr")[1] }
      let(:higher_rate_row) { html.all("tbody tr")[2] }

      context "basic rate" do
        it "renders threshold range for basic rate" do
          expect(basic_rate_row).to have_css("td", text: "£12,571 to £50,270")
        end

        it "renders rate for basic rate" do
          expect(basic_rate_row).to have_css("td", text: "20%")
        end
      end

      context "higher rate" do
        it "renders threshold range for higher rate" do
          expect(higher_rate_row).to have_css("td", text: "£50,271 to £125,140")
        end

        it "renders rate for basic rate" do
          expect(higher_rate_row).to have_css("td", text: "40%")
        end
      end
    end

    describe "first (additional rate) row (with lower threshold only)" do
      let(:additional_rate_row) { html.all("tbody tr").last }

      it "renders the band name" do
        expect(additional_rate_row).to have_css("td", text: "Additional rate")
      end

      it "renders 'over' with lower threshold" do
        expect(additional_rate_row).to have_css("td", text: "over £125,140")
      end

      it "renders the tax rate" do
        expect(additional_rate_row).to have_css("td", text: "45%")
      end
    end

    describe "edge cases (outside of current income tax table needs)" do
      context "when only a single rate is defined" do
        let(:rates) do
          [
            {
              name: "Flat rate",
              value: "10%",
              bands: [
                {
                  name: "All income",
                  lower_threshold: { value: "£0" },
                },
              ],
            },
          ]
        end

        it "renders the single row with 'over' prefix" do
          expect(html).to have_css("td", text: "over £0")
        end
      end

      context "when two rates are defined" do
        let(:rates) do
          [
            {
              name: "Basic",
              value: "0%",
              bands: [{ name: "Allowance", upper_threshold: { value: "£10,000" } }],
            },
            {
              name: "Standard",
              value: "20%",
              bands: [{ name: "Standard", lower_threshold: { value: "£10,001" } }],
            },
          ]
        end

        it "renders first row with 'Up to' prefix" do
          expect(html).to have_css("td", text: "Up to £10,000")
        end

        it "renders last row with 'over' prefix" do
          expect(html).to have_css("td", text: "over £10,001")
        end
      end
    end
  end
end
