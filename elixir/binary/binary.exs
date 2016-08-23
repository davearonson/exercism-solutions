defmodule Binary do
  @doc """
  Convert a string containing a binary number to an integer.

  On errors returns 0.
  """
  @spec to_decimal(String.t) :: non_neg_integer
  def to_decimal(string) do
    string
    |> String.graphemes
    |> do_binary(0)
  end

  defp do_binary(["0"|more], acc), do: do_binary(more, acc * 2)
  defp do_binary(["1"|more], acc), do: do_binary(more, acc * 2 + 1)
  defp do_binary([],         acc), do: acc
  defp do_binary(_,          _  ), do: 0

end
