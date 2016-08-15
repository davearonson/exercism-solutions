defmodule Grains do
  @doc """
  Calculate two to the power of the input minus one.
  """
  @spec square(pos_integer) :: pos_integer
  def square(number) do
    # COULD do a simple formula, 2**(number-1),
    # but wanna play with more Elixirish approaches....
    do_square(number)
  end

  defp do_square(1), do: 1
  defp do_square(number), do: 2 * square(number - 1)

  @doc """
  Adds square of each number from 1 to 64.
  """
  @spec total :: pos_integer
  def total do
    # COULD do a simple formula, 2**(num_squarea)-1,
    # but wanna play with more Elixirish approaches....
    do_total(64)
  end

  defp do_total(1), do: 1
  defp do_total(square_num) do
    # round it, else accumulated tiny errors can throw it off  :-(
    round(:math.pow(2, square_num - 1)) + do_total(square_num - 1)
  end
end
