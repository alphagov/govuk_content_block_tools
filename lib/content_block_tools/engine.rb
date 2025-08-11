require "rails/engine"
require "view_component"
require "view_component/version"

module ContentBlockTools
  class Engine < ::Rails::Engine
    isolate_namespace ContentBlockTools

    config.autoload_paths = %W[
      "#{root}/app/components"
    ]

    initializer "content_block_tools.assets" do
      if defined? Rails.application.config.assets
        Rails.application.config.assets.paths += %w[
          app/assets/stylesheets
          node_modules/govuk-frontend/dist/govuk/core
        ]
      end
    end

    initializer "content_block_tools.initialize_logger" do
      ContentBlockTools.logger = Rails.logger
    end
  end
end
