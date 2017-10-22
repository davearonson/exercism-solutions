module Pangram
  def self.is_pangram?(sentence)
    (("a".."z").to_a - sentence.downcase.chars).none?
  end
end

module BookKeeping
  VERSION = 2 # Where the version number matches the one in the test.
end
