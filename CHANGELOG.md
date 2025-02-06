# Changelog

- We use the [GOV.UK versioning guidelines](https://docs.publishing.service.gov.uk/manual/publishing-a-ruby-gem.html#versioning).
- Mark breaking changes with `BREAKING:`. Be sure to include instructions on how applications should be upgraded.
- Include a link to your pull request.
- Don't include changes that are purely internal. The CHANGELOG should be a
  useful summary for people upgrading their application, not a replication
  of the commit log.

## 0.4.2

* Pass embed code to HTML span ([19](https://github.com/alphagov/govuk_content_block_tools/pull/19))

## 0.4.1

* Fix field regular expression ([18](https://github.com/alphagov/govuk_content_block_tools/pull/18))

## 0.4.0

* BREAKING: allow support for field names in block's embed code. new ContentBlocks now require an embed code argument. (
  [17]
  (https://github.com/alphagov/govuk_content_block_tools/pull/17))

## 0.3.1

* Support any Rails version `>= 6` ([#10](https://github.com/alphagov/govuk_content_block_tools/pull/10))

## 0.3.0

* Symbolise details hash ([#8](https://github.com/alphagov/content_block_tools/pull/8))

## 0.2.1

* Loosen ActionView dependency ([#7](https://github.com/alphagov/content_block_tools/pull/7))

## 0.2.0

* Don't `uniq` content references ([#6](https://github.com/alphagov/content_block_tools/pull/6))

## 0.1.0

* Initial release
