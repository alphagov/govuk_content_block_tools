module ContentBlockTools
  # Represents the path to internal content within a content block
  #
  # An internal content path identifies a specific piece of content within a
  # content block's details hash. The path is used with `dig` to traverse the
  # nested structure.
  #
  # @example Path to a block
  #   path = InternalContentPath.new([:email_addresses, :main])
  #   path.present?    #=> true
  #   path.singular?   #=> false
  #   path.block_type  #=> :email_addresses
  #   path.block_name  #=> :main
  #
  # @example Path to a field in a one-to-one relationship
  #   path = InternalContentPath.new([:date_range])
  #   path.singular?   #=> true
  #   path.block_type  #=> :date_range
  #   path.block_name  #=> :date_range
  #
  # @example Empty path (render the whole block)
  #   path = InternalContentPath.new([])
  #   path.present?    #=> false
  #   path.block_type  #=> nil
  #
  class InternalContentPath
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def present?
      path.any?
    end

    def singular?
      path.one?
    end

    def block_type
      path.first
    end

    def block_name
      path.last
    end
  end
end
