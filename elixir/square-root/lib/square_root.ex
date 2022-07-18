defmodule SquareRoot do
  @doc """
  Calculate the integer square root of a positive integer
  """

  @spec calculate(radicand :: pos_integer) :: pos_integer
  def calculate(radicand) do
    do_calculate(radicand, 1, radicand)
  end

  defp do_calculate(radicand, min, max) do
    guess = trunc((min + max) / 2)
    square = guess * guess
    over = square - radicand
    cond do
      over > 0 -> do_calculate(radicand, min, guess - 1)
      over < 0 -> do_calculate(radicand, guess + 1, max)
      true     -> guess
    end
  end
end
