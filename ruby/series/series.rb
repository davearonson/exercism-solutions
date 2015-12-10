class Series

  def initialize(string)
    @numbers = string.chars.map(&:to_i)
  end

  def slices(slice_length)
    last_start = @numbers.length - slice_length
    if last_start < 0
      raise(ArgumentError,
            "Cannot take #{slice_length} items from an array of #{@numbers.length}")
    end
    (0..last_start).map { |start| @numbers[start, slice_length] }
  end

end
