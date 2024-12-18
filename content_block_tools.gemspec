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

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

  spec.add_development_dependency "rake", "13.2.1"
  spec.add_development_dependency "rspec", "3.13.0"
  spec.add_development_dependency "rubocop-govuk", "5.0.6"

  spec.add_dependency "actionview", ">= 6"
end
