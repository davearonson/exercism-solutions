class Prime

  @@primes = []

  def nth(nth)
    raise ArgumentError if nth < 1
    (2..Float::INFINITY).lazy.select { |n| prime?(n) }.first(nth).last
  end

  def prime?(number)
    root = Math.sqrt(number).floor
    stock_primes_up_to(root)
    result = @@primes.none? { |factor|
      if factor > root
        @@primes << number
        return true
      end
      number % factor == 0
    }
    @@primes << number if result
    result
  end
    
  def stock_primes_up_to(n)
    last = @@primes.last || 1
    ((last + 1) .. n).each { |i| @@primes << i if prime?(i) }
  end

end
