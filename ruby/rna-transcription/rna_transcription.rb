class Complement

  VERSION = 2

  def self.of_dna(dna)
    complement_with_pairs(dna, DNA_PAIRS)
  end

  def self.of_rna(rna)
    complement_with_pairs(rna, RNA_PAIRS)
  end

  private

  DNA_PAIRS = {
    "A" => "U",
    "C" => "G",
    "G" => "C",
    "T" => "A",
  }

  RNA_PAIRS = DNA_PAIRS.invert

  def self.complement_with_pairs(sequence, pairs)
    sequence.chars.map { |c|
      comp = pairs[c]
      comp ? comp : raise(ArgumentError)
    }.join
  end

end
