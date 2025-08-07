module ContentBlockTools
  module Presenters
    module BlockPresenters
      module Contact
        module BlockLevelContactItem
          BASE_TAG_TYPE = :div

          def initialize(item, content_block:, rendering_context: :block, **_args)
            @item = item
            @content_block = content_block
            @rendering_context = rendering_context
          end

          def wrapper(&block)
            content_tag(:div) do
              concat title
              concat yield block
            end
          end

          def title
            if @rendering_context == :field_names
              content_tag(:p,
                          @content_block.title,
                          class: "content-block__title")
            else
              content_tag(:p, item[:title], class: "content-block__subtitle")
            end
          end
        end
      end
    end
  end
end
