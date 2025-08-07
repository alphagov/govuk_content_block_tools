module ContentBlockTools
  class Engine < ::Rails::Engine
    isolate_namespace ContentBlockTools

    initializer "content_block_tools.initialize_logger" do
      ContentBlockTools.logger = Rails.logger
    end
  end
end
