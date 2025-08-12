# frozen_string_literal: true

require "simplecov"
SimpleCov.start do
  minimum_coverage 100
  add_filter "spec/dummy"
  add_filter "lib/content_block_tools/engine.rb"
end

require "bundler/setup"
require "securerandom"
require "rspec-html-matchers"

require File.expand_path("dummy/config/environment", __dir__)

RSpec.configure do |config|
  config.include RSpecHtmlMatchers

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
