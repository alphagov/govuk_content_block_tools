module ContentBlockTools
  module Components
    class BaseComponent < ViewComponent::Base
      def render
        render_in(view_context)
      end

    private

      def view_context
        ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil)
      end
    end
  end
end
