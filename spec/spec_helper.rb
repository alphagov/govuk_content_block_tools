# frozen_string_literal: true

require "bundler/setup"
require "securerandom"
require "rspec-html-matchers"

require "content_block_tools"

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
