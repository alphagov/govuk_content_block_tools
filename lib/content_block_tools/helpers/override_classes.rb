# Module for generating GOV.UK Design System CSS utility classes
module ContentBlockTools
  # Helper methods for generating override CSS classes
  # These methods generate CSS class names for spacing and typography utilities
  # from the GOV.UK Design System.
  module OverrideClasses
    # Generates margin CSS classes
    #
    # @param top [Integer, String] the margin value for all sides (if used alone) or top margin
    # @param right [Integer, String, nil] the right margin value (optional)
    # @param bottom [Integer, String, nil] the bottom margin value (optional)
    # @param left [Integer, String, nil] the left margin value (optional)
    # @return [String] the generated margin class(es)
    #
    # @example Generate uniform margin
    #   margin_classes(4)
    #   # => "govuk-!-margin-4"
    #
    # @example Generate individual side margins
    #   margin_classes(4, 3, 2, 1)
    #   # => "govuk-!-margin-top-4 govuk-!-margin-right-3 govuk-!-margin-bottom-2 govuk-!-margin-left-1"
    def margin_classes(top, right = nil, bottom = nil, left = nil)
      spacing_classes("margin", top, right, bottom, left)
    end

    # Generates padding CSS classes
    #
    # @param top [Integer, String] the padding value for all sides (if used alone) or top padding
    # @param right [Integer, String, nil] the right padding value (optional)
    # @param bottom [Integer, String, nil] the bottom padding value (optional)
    # @param left [Integer, String, nil] the left padding value (optional)
    # @return [String] the generated padding class(es)
    #
    # @example Generate uniform padding
    #   padding_classes(4)
    #   # => "govuk-!-padding-4"
    #
    # @example Generate individual side paddings
    #   padding_classes(4, 3, 2, 1)
    #   # => "govuk-!-padding-top-4 govuk-!-padding-right-3 govuk-!-padding-bottom-2 govuk-!-padding-left-1"
    def padding_classes(top, right = nil, bottom = nil, left = nil)
      spacing_classes("padding", top, right, bottom, left)
    end

    # Generates combined font size and weight CSS classes
    #
    # @param size [Integer, String] the font size value (e.g., 16, 19, 24)
    # @param weight [String, Symbol] the font weight value (e.g., "bold", "regular")
    # @return [String] the generated font size and weight classes separated by a space
    #
    # @example Generate font classes with size and weight
    #   font_classes(19, "bold")
    #   # => "govuk-!-font-size-19 govuk-!-font-weight-bold"
    #
    # @example Generate font classes with different values
    #   font_classes(24, "regular")
    #   # => "govuk-!-font-size-24 govuk-!-font-weight-regular"
    def font_classes(size, weight)
      [
        font_size_class(size),
        font_weight_class(weight),
      ].join(" ")
    end

    # Generates a font size CSS class
    #
    # @param size [Integer, String] the font size value (e.g., 16, 19, 24)
    # @return [String] the generated font size class
    #
    # @example
    #   font_size_class(19)
    #   # => "govuk-!-font-size-19"
    def font_size_class(size)
      "govuk-!-font-size-#{size}"
    end

    # Generates a font weight CSS class
    #
    # @param weight [String, Symbol] the font weight value (e.g., "bold", "regular")
    # @return [String] the generated font weight class
    #
    # @example
    #   font_weight_class("bold")
    #   # => "govuk-!-font-weight-bold"
    def font_weight_class(weight)
      "govuk-!-font-weight-#{weight}"
    end

  private

    def spacing_classes(type, top, right = nil, bottom = nil, left = nil)
      if right.nil? && bottom.nil? && left.nil?
        "govuk-!-#{type}-#{top}"
      else
        %W[govuk-!-#{type}-top-#{top} govuk-!-#{type}-right-#{right} govuk-!-#{type}-bottom-#{bottom} govuk-!-#{type}-left-#{left}].join(" ")
      end
    end
  end
end
