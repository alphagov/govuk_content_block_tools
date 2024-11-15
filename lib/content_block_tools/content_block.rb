module ContentBlockTools
  class ContentBlock < Data.define(:content_id, :title, :document_type, :details)
    # A lookup of presenters for particular content block types
    CONTENT_PRESENTERS = {
      "content_block_email_address" => ContentBlockTools::Presenters::EmailAddressPresenter,
    }.freeze

    # Calls the appropriate presenter class to return a HTML representation of a content
    # block. Defaults to {Presenters::BasePresenter}
    #
    # @returns [string] A HTML representation of the content block
    def render
      CONTENT_PRESENTERS
        .fetch(document_type, Presenters::BasePresenter)
        .new(self).render
    end
  end
end
