# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "content_block_tools/version"

Gem::Specification.new do |spec|
  spec.name          = "content_block_tools"
  spec.version       = ContentBlockTools::VERSION
  spec.authors       = ["GOV.UK Dev"]
  spec.email         = ["govuk-dev@digital.cabinet-office.gov.uk"]

  spec.summary       = "A suite of tools for working with GOV.UK Content Blocks"
  spec.homepage      = "https://github.com/alphagov/content_block_tools"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 3.2"
  spec.files = Dir[
    "{node_modules/govuk-frontend,app,lib}/**/*", "LICENCE.txt", "README.md"
  ]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

  spec.add_development_dependency "rake", "13.3.0"
  spec.add_development_dependency "rspec", "3.13.1"
  spec.add_development_dependency "rspec-html-matchers", "0.10.0"
  spec.add_development_dependency "rubocop-govuk", "5.1.18"

  spec.add_dependency "actionview", ">= 6"
  spec.add_dependency "govspeak", "10.6.1"
  spec.add_dependency "rails"
  spec.add_dependency "view_component", "4.0.1"
end
