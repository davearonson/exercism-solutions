class Raindrops

  def self.convert(num)
    output = ""
    NOISES.each { |factor, noise| output << noise if num % factor == 0 }
    output == "" ? num.to_s : output
  end

  private

  NOISES = {
    3 => "Pling",
    5 => "Plang",
    7 => "Plong"
  }

end
