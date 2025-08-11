# frozen_string_literal: true

require "action_view"
require "rails"
require "uri"
require "govspeak"
require "view_component/base"

require "content_block_tools/helpers/govspeak"

require "content_block_tools/components/base_component"
require "content_block_tools/presenters/field_presenters/base_presenter"
require "content_block_tools/presenters/field_presenters/contact/email_address_presenter"

require "content_block_tools/presenters/block_presenters/base_presenter"
require "content_block_tools/presenters/block_presenters/contact/address_presenter"
require "content_block_tools/presenters/block_presenters/contact/contact_link_presenter"
require "content_block_tools/presenters/block_presenters/contact/email_address_presenter"
require "content_block_tools/presenters/block_presenters/contact/telephone_presenter"

require "content_block_tools/presenters/base_presenter"
require "content_block_tools/presenters/contact_presenter"
require "content_block_tools/presenters/pension_presenter"

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
