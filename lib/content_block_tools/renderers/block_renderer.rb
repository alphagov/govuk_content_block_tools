module ContentBlockTools
  module Renderers
    # Renders an entire content block by rendering each of its fields and blocks
    # using the appropriate presenters.
    class BlockRenderer
      attr_reader :content_block

      # Initializes the BlockRenderer with a content block.
      #
      # @param content_block [Object] The content block to be rendered.
      def initialize(content_block)
        @content_block = content_block
      end

      # Renders the entire content block.
      #
      # Iterates over each field or embedded block in the content block
      # and appends the rendered output.
      #
      # @return [void]
      def render
        rendered_fields.join.html_safe
      end

    private

      # Collects and renders all fields in the content block.
      #
      # @return [Array<String>] The rendered output for each field or block.
      def rendered_fields
        content_block.field_order.flat_map do |item|
          if item.is_a?(Hash)
            item.flat_map do |object_type, item_keys|
              render_block(object_type, item_keys)
            end
          else
            render_field(item.to_sym)
          end
        end
      end

      # Renders a single field.
      #
      # @param field_name [Symbol] The name of the field to render.
      # @return [String] The rendered content.
      def render_field(field_name)
        item = field_name == :title ? content_block.title : content_block.details[field_name]
        fetch_presenter(:field, field_name).new(item).render
      end

      # Renders an embedded block of content.
      #
      # @param object_type [Symbol] The type of the embedded object (e.g., :contacts).
      # @param item_keys [Array<String>] Keys identifying individual items within the object type.
      # @return [Array<String>] Rendered embedded items.
      def render_block(object_type, item_keys)
        item_keys.map do |item_key|
          embedded_item = content_block.details.dig(object_type, item_key.to_sym)
          fetch_presenter(:block, object_type).new(embedded_item).render
        end
      end

      # Dynamically resolves the presenter class for a given object type, defaulting to the default if no presenter can
      # be found.
      #
      # @param render_type [Symbol] The type of presenter (either :block or :field).
      # @param object_type [Symbol] The type of object (e.g., :contacts).
      # @return [Class] The presenter class.
      def fetch_presenter(render_type, object_type)
        namespace = [
          "ContentBlockTools",
          "Presenters",
          "#{render_type.to_s.capitalize}Presenters",
          document_type.to_s.camelize,
          "#{object_type.to_s.singularize.camelize}Presenter",
        ]

        namespace.join("::").constantize
      rescue NameError
        if render_type == :block
          ContentBlockTools::Presenters::BlockPresenters::BasePresenter
        else
          ContentBlockTools::Presenters::FieldPresenters::BasePresenter
        end
      end

      def document_type
        content_block.document_type.gsub("content_block", "")
      end
    end
  end
end
