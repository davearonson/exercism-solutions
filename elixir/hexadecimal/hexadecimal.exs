defmodule Hexadecimal do
  @doc """
    Accept a string representing a hexadecimal value and returns the
    corresponding decimal value.
    It returns the integer 0 if the hexadecimal is invalid.
    Otherwise returns an integer representing the decimal value.

    ## Examples

      iex> Hexadecimal.to_decimal("invalid")
      0

      iex> Hexadecimal.to_decimal("af")
      175

  """

  @spec to_decimal(binary) :: integer
  def to_decimal(hex) do
    do_to_decimal(hex |> String.downcase |> String.graphemes, 0)
  end

  @hex_digits "0123456789abcdef"
  defp do_to_decimal([]          , acc), do: acc
  defp do_to_decimal([digit|more], acc)  do
    case :binary.match(@hex_digits, digit) do
      {index, _} -> do_to_decimal(more, acc * 16 + index)
      _ -> 0
    end
  end

end
