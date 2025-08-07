module ContentBlockTools
  class Engine < ::Rails::Engine
    isolate_namespace ContentBlockTools

    initializer "content_block_tools.assets" do
      Rails.application.config.assets.paths += %w[
        app/assets/stylesheets
        node_modules/govuk-frontend/dist/govuk/core
      ]
    end

    initializer "content_block_tools.initialize_logger" do
      ContentBlockTools.logger = Rails.logger
    end
  end
end
