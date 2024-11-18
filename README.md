# Content Block Tools

A suite of tools for working with GOV.UK Content Blocks

## Installation

Install the gem

    gem install content_block_tools

or add it to your Gemfile

    gem "content_block_tools"

## Usage

### Finding embed code

To find embed code in a block of text, use `ContentBlockReference.find_all_in_document`:

```ruby
content = "Hello - here is a embed code {{embed:content_block_email_address:be24ee44-b636-4a3e-b979-0da27b4a8e62}}"
ContentBlockReference.find_all_in_document(content)
# =>
#[#<data ContentBlockTools::ContentBlockReference
#  document_type="content_block_email_address",
#  content_id="be24ee44-b636-4a3e-b979-0da27b4a8e62",
#  embed_code="{{embed:content_block_email_address:be24ee44-b636-4a3e-b979-0da27b4a8e62}}">]
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
