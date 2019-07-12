class Raindrops

  def self.convert(num)
    output = NOISES.map { |factor, noise| noise if num % factor == 0 }
    # trick: nils (from above) are falsey, and "arr.any?" means
    # "arr.any? { |elt| elt.truthy? }", NOT "arr.size > 0"!
    return output.any? ? output.join : num.to_s
  end

  private

  NOISES = { 3 => "Pling", 5 => "Plang", 7 => "Plong" }

end
