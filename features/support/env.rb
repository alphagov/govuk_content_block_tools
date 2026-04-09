# frozen_string_literal: true

require "bundler/setup"
require "securerandom"
require "rspec/expectations"
require "rspec/mocks"
require "rspec-html-matchers"

# Load the dummy Rails app (same as RSpec uses)
require File.expand_path("../../spec/dummy/config/environment", __dir__)

World(RSpec::Matchers)
World(RSpec::Mocks::ExampleMethods)
World(RSpecHtmlMatchers)

# Enable RSpec mocks in Cucumber
Around do |_scenario, block|
  RSpec::Mocks.setup
  block.call
  RSpec::Mocks.verify
ensure
  RSpec::Mocks.teardown
end
