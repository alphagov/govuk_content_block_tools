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
            if @rendering_context == :field_names
              content_tag(:div, class: "contact") do
                concat title if show_title_in_field_names_context?
                concat yield block
              end
            else
              yield block
            end
          end

          def title
            content_tag(:p,
                        @content_block.title,
                        class: "govuk-!-margin-bottom-3")
          end

        private

          def show_title_in_field_names_context?
            true
          end
        end
      end
    end
  end
end
