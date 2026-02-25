module ContentBlockTools
  class TimePeriodComponent < ContentBlockTools::BaseComponent
    def initialize(content_block:, _block_type: nil, _block_name: nil)
      @content_block = content_block
    end

    def start_date
      presented_date(
        content_block.details.dig(:date_range, :start, :date),
      )
    end

    def end_date
      presented_date(
        content_block.details.dig(:date_range, :end, :date),
      )
    end

  private

    attr_reader :content_block

    def presented_date(date)
      Presenters::FieldPresenters::TimePeriod::DatePresenter.new(
        date,
      ).render
    end
  end
end
