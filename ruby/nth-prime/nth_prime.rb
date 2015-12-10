class Prime

  def self.nth(which)
    if which <= 0
      raise(ArgumentError,
            "Argument of #{self.class.name} must be at least 1")
    end
    generate_primes_up_to_nth(which)
    @@primes[which-1]
  end

  private

  @@primes = []

  def self.generate_primes_up_to_nth(count)
    candidate = @@primes.last || 1
    while @@primes.length < count
      candidate += 1
      @@primes << candidate if is_prime?(candidate)
    end
  end

  def self.is_prime?(n)
    root = Math.sqrt(n)
    @@primes.none? { |p|
      return true if p > root
      n % p == 0 }
  end

end
