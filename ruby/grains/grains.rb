module Grains

  def self.square(i)
    2 ** (i - 1)
  end

  def self.total
    2 ** SQUARES - 1
  end

  private

  SQUARES = 64

end
