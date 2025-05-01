# frozen_string_literal: true

require "action_view"
require "uri"

require "content_block_tools/presenters/base_presenter"
require "content_block_tools/presenters/contact_presenter"
require "content_block_tools/presenters/email_address_presenter"
require "content_block_tools/presenters/postal_address_presenter"
require "content_block_tools/presenters/pension_presenter"

require "content_block_tools/content_block"
require "content_block_tools/content_block_reference"

require "content_block_tools/version"

module ContentBlockTools
  class Error < StandardError; end
  module Presenters; end

  class << self
    attr_writer :logger

    def logger
      @logger ||= Logger.new($stdout)
    end
  end

  if defined?(Rails::Railtie)
    class Railtie < Rails::Railtie
      initializer "content_block_tools.initialize_logger" do
        ContentBlockTools.logger = Rails.logger
      end
    end
  end
end
