module ContentBlockTools
  class TimePeriodComponent < ContentBlockTools::BaseComponent
    def initialize(content_block:, _block_type: nil, _block_name: nil)
      @content_block = content_block
      @normalised_date_range = normalise_date_range
    end

    def start_date
      presented_date(normalised_date_range.start_date)
    end

    def end_date
      presented_date(normalised_date_range.end_date)
    end

  private

    attr_reader :content_block, :normalised_date_range

    def normalise_date_range
      NormalisedDateRange.new(content_block.details[:date_range])
    end

    def presented_date(date)
      return unless date.present?

      Presenters::FieldPresenters::TimePeriod::DatePresenter.new(
        date,
      ).render
    end
  end
end
