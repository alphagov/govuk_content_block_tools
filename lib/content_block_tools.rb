# frozen_string_literal: true

require "action_view"

require "content_block_tools/presenters/base_presenter"
require "content_block_tools/presenters/email_address_presenter"

require "content_block_tools/content_block"
require "content_block_tools/content_block_reference"

require "content_block_tools/version"

module ContentBlockTools
  class Error < StandardError; end
  module Presenters; end
end
