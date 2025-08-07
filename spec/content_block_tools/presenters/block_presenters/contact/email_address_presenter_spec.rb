RSpec.describe ContentBlockTools::Presenters::BlockPresenters::Contact::EmailAddressPresenter do
  let(:content_block) do
    ContentBlockTools::ContentBlock.new(
      document_type: "something",
      title: "My content block",
      details: {},
      content_id: 123,
      embed_code: "something",
    )
  end

  let(:email_address) do
    {
      "title": "Email",
      "label": "Email us",
      "email_address": "foo@example.com",
    }
  end

  it "should render successfully" do
    presenter = described_class.new(email_address, content_block:)

    expect(presenter.render).to have_tag("ul", with: { class: "content-block__list" }) do
      with_tag("li") do
        with_tag("a", text: "Email us", with: { href: "mailto:foo@example.com", class: "email content-block__link" })
      end
    end
  end

  describe "when the label is not present" do
    let(:email_address) do
      {
        "title": "Email",
        "email_address": "foo@example.com",
      }
    end

    it "uses the email address as the link text" do
      presenter = described_class.new(email_address, content_block:)

      expect(presenter.render).to have_tag("ul", with: { class: "content-block__list" }) do
        with_tag("li") do
          with_tag("a", text: "foo@example.com", with: { href: "mailto:foo@example.com", class: "email content-block__link" })
        end
      end
    end
  end

  describe "when subject and body are present" do
    let(:email_address) do
      {
        "title": "Some email address",
        "email_address": "foo@example.com",
        "subject": "My email",
        "body": "Body text here",
      }
    end

    it "should render successfully" do
      presenter = described_class.new(email_address, content_block:)

      expect(presenter.render).to have_tag("ul", with: { class: "content-block__list" }) do
        with_tag("li") do
          with_tag("a", text: "foo@example.com", with: { href: "mailto:foo@example.com?subject=My email&body=Body text here", class: "email content-block__link" })
        end
      end
    end
  end

  describe "when a description is present" do
    let(:email_address) do
      {
        "title": "Email us",
        "label": "Some email address",
        "email_address": "foo@example.com",
        "description": "Description text",
      }
    end

    it "should render successfully" do
      presenter = described_class.new(email_address, content_block:)

      expect(presenter).to receive(:render_govspeak)
                             .with("Description text")
                             .and_call_original

      expect(presenter.render).to have_tag("ul", with: { class: "content-block__list" }) do
        with_tag("li") do
          with_tag("a", text: "Some email address", with: { href: "mailto:foo@example.com", class: "email content-block__link" })
        end

        with_tag("li") do
          with_tag("p", text: "Description text")
        end
      end
    end
  end

  describe "when rendering in the field_names context" do
    it "should wrap in a contact class with the content block's title" do
      presenter = described_class.new(email_address, rendering_context: :field_names, content_block:)
      result = presenter.render

      expect(result).to have_tag("div") do
        with_tag("p", text: content_block.title, with: { class: "content-block__title" })
        with_tag("ul", with: { class: "content-block__list" })
      end
    end
  end
end
