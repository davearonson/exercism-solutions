defmodule Luhn do
  @doc """
  Calculates the total checksum of a number
  """
  @spec checksum(String.t()) :: integer
  def checksum(number_as_string) do
    number_as_string
    |> String.graphemes
    |> Enum.map(&String.to_integer &1)
    |> Enum.reverse
    |> do_checksum(0)
  end

  defp do_checksum([single|[double|more]], acc) do
    do_checksum(more, acc + double_value(double) + single)
  end
  defp do_checksum([single], acc), do: acc + single
  defp do_checksum([],       acc), do: acc

  defp double_value(digit) when digit < 5, do: digit * 2
  defp double_value(digit)               , do: digit * 2 - 9

  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number_as_string) do
    rem(checksum(number_as_string), 10) == 0
  end

  @doc """
  Creates a valid number by adding the correct
  checksum digit to the end of the number
  """
  @spec create(String.t()) :: String.t()
  def create(number_as_string) do
    "#{number_as_string}#{check_digit(number_as_string)}"
  end

  defp check_digit(number_as_string) do
    make_non_negative(-rem(checksum("#{number_as_string}0"), 10))
  end

  defp make_non_negative(0), do: 0
  defp make_non_negative(n), do: n + 10

end
