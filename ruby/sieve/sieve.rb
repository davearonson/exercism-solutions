require "Set"

class Sieve

  def initialize(number)
    @number = number
  end

  # "mark" them by *removing* them.
  # that's why a set, as removal is so much faster than an array.
  # other optimizations:
  # - stop checking for primes after [floor of] square root of limit;
  #   any higher composites are also multiples of same or lower prime.
  # - start multiple-marking with prime's square;
  #   any lower multiples are multiples of some previous prime.
  def primes
    possible_primes = Set.new(2..@number)
    (2..Math.sqrt(@number)).each do |prime|
      next unless possible_primes.include? prime
      factors = prime..(@number/prime).floor
      multiples = factors.map { |factor| factor * prime }
      possible_primes.subtract multiples
    end
    possible_primes.to_a
  end
end
