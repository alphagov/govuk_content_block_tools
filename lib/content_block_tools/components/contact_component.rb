module ContentBlockTools
  module Components
    class ContactComponent < ContentBlockTools::Components::BaseComponent
      BLOCK_TYPES = %i[addresses email_addresses telephones contact_links].freeze

      def initialize(content_block:, block_type: nil, block_name: nil)
        @content_block = content_block
        @block_type = block_type
        @block_name = block_name
      end

    private

      attr_reader :content_block, :block_type, :block_name

      def component_for_block_type(block_type)
        "ContentBlockTools::Components::Contacts::#{block_type.to_s.singularize.camelize}Component".constantize
      end

      def content_by_block_type
        @content_by_block_type ||= content_block.details.keys.map { |key|
          [key, content_block.details[key]&.values]
        }.to_h
      end

      def item_to_render
        content_block.details.dig(block_type, block_name)
      end
    end
  end
end
