defmodule ArmstrongNumber do
  @moduledoc """
  Provides a way to validate whether or not a number is an Armstrong number
  """

  @spec valid?(integer) :: boolean
  def valid?(number) do
    digits = Integer.digits(number)
    num_digits = length(digits)
    check =
      digits
      |> Enum.map(&:math.pow(&1, num_digits))
      |> Enum.sum()
    number == check
  end
end
