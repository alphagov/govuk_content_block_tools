RSpec.describe ContentBlockTools::Presenters::BlockPresenters::Contact::AddressPresenter do
  let(:address) do
    {
      "title": "Some address",
      "street_address": "123 Fake Street",
      "locality": "Springton",
      "region": "Missouri",
      "postal_code": "TEST 123",
      "country": "USA",
    }
  end

  it "should render successfully" do
    presenter = described_class.new(address)

    expect(presenter.render).to have_tag("p") do
      with_text "123 Fake Street,Springton,Missouri,TEST 123,USA"
      with_tag "br", count: 4
    end
  end

  describe "when some fields are missing" do
    let(:address) do
      {
        "title": "Some address",
        "street_address": "123 Fake Street",
        "region": "",
        "locality": "Springton",
        "postal_code": "TEST 123",
        "country": "",
      }
    end

    it "should ignore the missing fields" do
      presenter = described_class.new(address)

      expect(presenter.render).to have_tag("p") do
        with_text "123 Fake Street,Springton,TEST 123"
        with_tag "br", count: 2
      end
    end
  end
end
