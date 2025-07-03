module ContentBlockTools
  module Presenters
    module BlockPresenters
      module Contact
        module BlockLevelContactItem
          BASE_TAG_TYPE = :div

          def initialize(item, rendering_context: :block, **_args)
            @item = item
            @rendering_context = rendering_context
          end

          def wrapper(&block)
            if @rendering_context == :field_names
              content_tag(:div, class: "contact") do
                yield block
              end
            else
              yield block
            end
          end
        end
      end
    end
  end
end
