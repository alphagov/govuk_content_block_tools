# Changelog

- We use the [GOV.UK versioning guidelines](https://docs.publishing.service.gov.uk/manual/publishing-a-ruby-gem.html#versioning).
- Mark breaking changes with `BREAKING:`. Be sure to include instructions on how applications should be upgraded.
- Include a link to your pull request.
- Don't include changes that are purely internal. The CHANGELOG should be a
  useful summary for people upgrading their application, not a replication
  of the commit log.

## 1.1.0

- Replace block-level presenters with Components ([81](https://github.com/alphagov/govuk_content_block_tools/pull/81))

## 1.0.3

- Import govuk-links ([80](https://github.com/alphagov/govuk_content_block_tools/pull/80))

## 1.0.2

- Only add paths to assets if `assets` is defined ([79](https://github.com/alphagov/govuk_content_block_tools/pull/79))

## 1.0.1

- Include `node_modules` directory in published gem ([78](https://github.com/alphagov/govuk_content_block_tools/pull/78))

## 1.0.0

- Add portable styling to the gem ([76](https://github.com/alphagov/govuk_content_block_tools/pull/76))
- Update contact blocks to match design system ([76](https://github.com/alphagov/govuk_content_block_tools/pull/76))

## 0.17.0

- Use recipient field in address ([75](https://github.com/alphagov/govuk_content_block_tools/pull/75))

## 0.16.0

- Use label as link text for contact link ([74](https://github.com/alphagov/govuk_content_block_tools/pull/74))
- Add description to contact link ([74](https://github.com/alphagov/govuk_content_block_tools/pull/74))
- Use label as link text for contact link ([74](https://github.com/alphagov/govuk_content_block_tools/pull/74))

## 0.15.0

- Rename content block classes ([72](https://github.com/alphagov/govuk_content_block_tools/pull/72))

## 0.14.0

- Update telephone to support simple opening hours ([71](https://github.com/alphagov/govuk_content_block_tools/pull/71))

## 0.13.0

- Rename Contact Form to Contact Link ([70](https://github.com/alphagov/govuk_content_block_tools/pull/70))

## 0.12.3

- Only replace special dashes in identifiers ([69](https://github.com/alphagov/govuk_content_block_tools/pull/69))

## 0.12.2

- Add escape character to silence warnings ([65](https://github.com/alphagov/govuk_content_block_tools/pull/65))

## 0.12.1

- Fix when content block codes include special dashes ([64](https://github.com/alphagov/govuk_content_block_tools/pull/64))

## 0.12.0

- Add missing fields for contact object ([62](https://github.com/alphagov/govuk_content_block_tools/pull/62))

## 0.11.0

- Update address and contact presenter to match model changes([61](https://github.com/alphagov/govuk_content_block_tools/pull/61))

## 0.10.0

- Add content block titles to individual contact blocks ([60](https://github.com/alphagov/govuk_content_block_tools/pull/60))
- Render title and description within telephone blocks ([60](https://github.com/alphagov/govuk_content_block_tools/pull/60))

## 0.9.0

- Render addresses within a `contact` div ([58](https://github.com/alphagov/govuk_content_block_tools/pull/58))

## 0.8.0

- Add wrapper classes to contact sub-blocks ([57](https://github.com/alphagov/govuk_content_block_tools/pull/57))

## 0.7.0

- Alter markup of contact ([55](https://github.com/alphagov/govuk_content_block_tools/pull/55))
- Handle when opening hours are missing ([55](https://github.com/alphagov/govuk_content_block_tools/pull/55))

## 0.6.5

- Add opening hours to a contact block ([52](https://github.com/alphagov/govuk_content_block_tools/pull/52))

## 0.6.4

- Fix rendering of block when UK call charges are not shown ([54](https://github.com/alphagov/govuk_content_block_tools/pull/54))

## 0.6.3

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
