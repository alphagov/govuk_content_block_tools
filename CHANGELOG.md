# Changelog

- We use the [GOV.UK versioning guidelines](https://docs.publishing.service.gov.uk/manual/publishing-a-ruby-gem.html#versioning).
- Mark breaking changes with `BREAKING:`. Be sure to include instructions on how applications should be upgraded.
- Include a link to your pull request.
- Don't include changes that are purely internal. The CHANGELOG should be a
  useful summary for people upgrading their application, not a replication
  of the commit log.

## Unreleased

- Fix rendering telephone numbers and rendering individual nested fields ([53](https://github.com/alphagov/govuk_content_block_tools/pull/53))

## 0.6.2

- Handle UK call charges for a Contact block, remove links from telephone numbers ([51](https://github.com/alphagov/govuk_content_block_tools/pull/51))

## 0.6.1

- Handle multiple telephone numbers for a Contact block ([48](https://github.com/alphagov/govuk_content_block_tools/pull/48)

## 0.6.0

- Support rendering nested blocks ([45](https://github.com/alphagov/govuk_content_block_tools/pull/45))

## 0.5.4

- Remove old email_address and postal_address types ([38](https://github.com/alphagov/govuk_content_block_tools/pull/38))

## 0.5.3

- Add spacing to contact item titles ([35](https://github.com/alphagov/govuk_content_block_tools/pull/35))
- Add new fields to contact items ([35](https://github.com/alphagov/govuk_content_block_tools/pull/35))

## 0.5.2

- Use `deep_symbolize_keys` when initializing a block's details  ([31](https://github.com/alphagov/govuk_content_block_tools/pull/31))

## 0.5.1

- Update dependencies
- Create a presenter for Contact Blocks ([30](https://github.com/alphagov/govuk_content_block_tools/pull/30))

## 0.5.0

- Support Content ID aliases ([27](https://github.com/alphagov/govuk_content_block_tools/pull/27))

## 0.4.6
- Remove noisy log ([25](https://github.com/alphagov/govuk_content_block_tools/pull/25))

## 0.4.5

- Add handling for incorrect field names and some logging ([24](https://github.com/alphagov/govuk_content_block_tools/pull/24))

## 0.4.4

- symbolize keys in block details blob, in order to find embedded nested fields ([22](https://github.com/alphagov/govuk_content_block_tools/pull/22))

## 0.4.3

- Add presenter for a pension block ([20](https://github.com/alphagov/govuk_content_block_tools/pull/20))

## 0.4.2

- Pass embed code to HTML span ([19](https://github.com/alphagov/govuk_content_block_tools/pull/19))

## 0.4.1

- Fix field regular expression ([18](https://github.com/alphagov/govuk_content_block_tools/pull/18))

## 0.4.0

- BREAKING: allow support for field names in block's embed code. new ContentBlocks now require an embed code argument. (
  [17]
  (https://github.com/alphagov/govuk_content_block_tools/pull/17))

## 0.3.1

- Support any Rails version `>= 6` ([#10](https://github.com/alphagov/govuk_content_block_tools/pull/10))

## 0.3.0

- Symbolise details hash ([#8](https://github.com/alphagov/content_block_tools/pull/8))

## 0.2.1

- Loosen ActionView dependency ([#7](https://github.com/alphagov/content_block_tools/pull/7))

## 0.2.0

- Don't `uniq` content references ([#6](https://github.com/alphagov/content_block_tools/pull/6))

## 0.1.0

- Initial release
