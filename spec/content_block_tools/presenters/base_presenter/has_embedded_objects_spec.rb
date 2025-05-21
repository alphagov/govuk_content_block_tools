class MyTestPresenter < ContentBlockTools::Presenters::BasePresenter
  has_embedded_objects :foo, :bar
end

RSpec.describe "ContentBlockTools::Presenters::BasePresenter.has_embedded_objects" do
  let(:content_id) { SecureRandom.uuid }

  let(:content_block) do
    ContentBlockTools::ContentBlock.new(
      document_type: "something",
      content_id:,
      title: "My content block",
      details:,
      embed_code: "something",
    )
  end

  let(:details) { {} }

  let(:described_class) { MyTestPresenter }

  let(:presenter) { described_class.new(content_block) }

  it "returns an empty array by default for defined objects" do
    expect(presenter.foo).to eq([])
    expect(presenter.bar).to eq([])
  end

  describe "when embedded objects are present" do
    let(:details) do
      {
        foo: {
          something: {
            field1: "Hi",
            field2: "Bye",
          },
          something_else: {
            field1: "Something",
            field2: "Else",
          },
        },
        bar: {
          something: {
            other_field1: "Other Hi",
            other_field2: "Other Bye",
          },
          something_else: {
            other_field1: "Other Something",
            other_field2: "Other Else",
          },
        },
      }
    end

    it "returns the expected values" do
      expect(presenter.foo).to eq([
        {
          field1: "Hi",
          field2: "Bye",
        },
        {
          field1: "Something",
          field2: "Else",
        },
      ])

      expect(presenter.bar).to eq([
        {
          other_field1: "Other Hi",
          other_field2: "Other Bye",
        },
        {
          other_field1: "Other Something",
          other_field2: "Other Else",
        },
      ])
    end
  end
end
