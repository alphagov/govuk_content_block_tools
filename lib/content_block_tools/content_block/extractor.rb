module ContentBlockTools
  class ContentBlock
    class Extractor
      # Returns a new `ContentBlockTools::ContentBlock::Extractor` object.
      #
      # For example:
      #
      #     result = ContentBlockTools::ContentBlock::Extractor.new(content)
      #
      # @param [String] document  A string of text
      #
      # @return [ContentBlockTools::ContentBlock::Extractor]
      def initialize(document)
        @document = document
      end

      # Finds all content block references within a document, using `ContentBlock::EMBED_REGEX`
      # to scan through the document
      #
      # @return [Array<ContentBlock>] An array of content blocks
      def content_references
        @content_references ||= @document.scan(ContentBlock::EMBED_REGEX).map { |match|
          ContentBlock.new(document_type: match[1], content_id: match[2], embed_code: match[0])
        }.uniq
      end

      # Finds all the UUIDs for content block references within a document
      #
      # @return [Array<String>] An array of UUIDs
      def content_ids
        @content_ids ||= content_references.map(&:content_id)
      end
    end
  end
end
