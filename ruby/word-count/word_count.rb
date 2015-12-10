class Phrase

  VERSION = 1

  def initialize(words)
    @words = words
  end
  
  def word_count
    Hash.new(0).tap { |counts|
      @words.split(/[^\w']+/).each { |word|
        counts[canonicalize(word)] += 1
      }
    }
  end

  private

  # downcase and remove any leading/trailing single-quotes,
  # since they're the same char as apostrophe
  def canonicalize(word)
    word.downcase.gsub(/\A'+/, "").gsub(/'+\Z/, "")
  end

end
