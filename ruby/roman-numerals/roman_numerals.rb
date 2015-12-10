module RomanNumerals

  def self.to_roman(n)
    if n > limit
      raise(ArgumentError,
            "Sorry, this implementation of Roman Numerals is limited to #{limit}.")
    end
    POWERS_OF_TEN.each_with_index.map { |char, zeroes|
      get_roman_letters(n, char, zeroes)
    }.reverse.join
  end

  private

  # we have been promised we won't need any more than M (limited to
  # 3999), though this algorithm will accomodate more, just by adding
  # them to this list.  one more letter would let us to get up to
  # 8999.  the romans actually used a v with a bar over it, for 500,
  # but that is non-ascii, so i'm not going to.
  POWERS_OF_TEN      = %w(I X C M)
  FIVE_POWERS_OF_TEN = %w(V L D)

  def self.get_roman_letters(number, single, zeroes)
    count = (number / 10 ** zeroes) % 10
    case count
    when 0..3 then single * count
    when 4    then single + FIVE_POWERS_OF_TEN[zeroes]
    when 5..8 then FIVE_POWERS_OF_TEN[zeroes] + single * (count - 5)
    when 9    then single + POWERS_OF_TEN[zeroes + 1]
    end
  end

  def self.limit
    # assuming the tens list is never shorter than the fives,
    # nor more than one entry longer.  else it's really weird....
    factor = POWERS_OF_TEN.length > FIVE_POWERS_OF_TEN.length ? 4 : 9
    @limit ||= 10 ** (POWERS_OF_TEN.length - 1) * factor - 1
  end

end

class Fixnum
  def to_roman
    RomanNumerals.to_roman(self)
  end
end
