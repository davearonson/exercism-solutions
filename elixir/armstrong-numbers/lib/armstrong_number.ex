defmodule ArmstrongNumber do
  @moduledoc """
  Provides a way to validate whether or not a number is an Armstrong number
  """

  @spec valid?(integer) :: boolean
  def valid?(number) do
    digits = Integer.to_string(number)
    num_digits = String.length(digits)
    check =
      digits
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> Enum.map(&:math.pow(&1, num_digits))
      |> Enum.sum()
    number == check
  end
end
