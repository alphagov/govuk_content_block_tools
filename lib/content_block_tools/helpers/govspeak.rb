module ContentBlockTools
  module Govspeak
    def render_govspeak(body, root_class: nil)
      html = ::Govspeak::Document.new(body).to_html
      Nokogiri::HTML.fragment(html).tap { |fragment|
        fragment.children[0].add_class(root_class) if root_class
      }.to_s.html_safe
    end
  end
end
