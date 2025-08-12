# frozen_string_literal: true

require "action_view"
require "uri"
require "govspeak"

require "content_block_tools/helpers/govspeak"

require "content_block_tools/presenters/field_presenters/base_presenter"
require "content_block_tools/presenters/field_presenters/contact/email_presenter"

require "content_block_tools/content_block"
require "content_block_tools/content_block_reference"

require "content_block_tools/engine"

require "content_block_tools/version"

module ContentBlockTools
  class Error < StandardError; end
  module Presenters; end

  module Components
    module Contacts; end
  end

  class << self
    attr_writer :logger

    def logger
      @logger ||= Logger.new($stdout)
    end
  end
end
