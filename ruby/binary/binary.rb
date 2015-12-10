class Binary

  VERSION = 1

  def initialize(string)
    if (matches = string.match(/[^01]/))
      raise(ArgumentError,
            "Invalid char '#{matches[0]}' binary string '#{string}'")
    end
    @binary_string = string
  end

  def to_decimal
    @binary_string.chars.reverse.each_with_index.
      reject { |digit, idx| digit == '0' }.
      map { |_, idx| 2 ** idx }.
      inject(0, &:+)
  end

end
