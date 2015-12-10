class Squares

  def initialize(how_many)
    @how_many = how_many
  end

  def difference
    square_of_sums - sum_of_squares
  end

  def square_of_sums
    # n*(n+1)/2 is standard formula for sum(1..n)
    (@how_many * (@how_many + 1) / 2) ** 2
  end

  def sum_of_squares
    # from https://en.wikipedia.org/wiki/Square_pyramidal_number
    (2 * @how_many**3 + 3 * @how_many**2 + @how_many) / 6
  end

end
