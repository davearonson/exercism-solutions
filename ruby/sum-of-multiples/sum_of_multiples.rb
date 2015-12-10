class SumOfMultiples

  def initialize(*factors)
    @factors = factors.empty? ? DEFAULT_FACTORS : factors
  end

  def to(limit)
    self.class.to(limit, @factors)
  end

  def self.to(limit, factors = DEFAULT_FACTORS)
    (1...limit).select { |number|
      factors.any? { |factor| number % factor == 0 }
    }.inject(0, &:+) # need 0 to satisfy "to(1)" case
  end

  private

  DEFAULT_FACTORS = [3, 5]

end
