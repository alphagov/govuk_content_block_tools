module ContentBlockTools
  class ContactComponent < ContentBlockTools::BaseComponent
    BLOCK_TYPES = %i[addresses email_addresses telephones contact_links].freeze

    def initialize(content_block:, block_type: nil, block_name: nil)
      @content_block = content_block
      @block_type = block_type
      @block_name = block_name
    end

  private

    attr_reader :content_block, :block_type, :block_name

    def items
      BLOCK_TYPES.each_with_object([]) do |block_type, items|
        content_block.details.fetch(block_type, {}).each do |key, item|
          items << [block_type, key, item]
        end
      end
    end

    def component_for_block_type(block_type)
      "ContentBlockTools::Contacts::#{block_type.to_s.singularize.camelize}Component".constantize
    end

    def item_to_render
      content_block.details.dig(block_type, block_name)
    end
  end
end
