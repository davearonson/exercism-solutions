class Hamming

  VERSION = 1

  def self.compute(a, b)
    if a.length != b.length
      raise(ArgumentError,
            "Arguments of #{self.class.name}.compute must be of same length")
    end
    (0...a.length).count { |i| a[i] != b[i] }
  end

end
