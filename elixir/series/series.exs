defmodule StringSeries do
  @doc """
  Given a string `s` and a positive integer `size`, return all substrings
  of that size. If `size` is greater than the length of `s`, or less than 1,
  return an empty list.
  """
  @spec slices(s :: String.t(), size :: integer) :: list(String.t())
  def slices(s, size) do
    do_slices(String.graphemes(s), size, [])
  end

  defp do_slices(_s, size, _acc) when size <= 0, do: []
  defp do_slices(s, size, acc) when length(s) < size, do: acc |> Enum.reverse
  defp do_slices(s, size, acc) do
    substr = s |> Enum.take(size) |> Enum.join 
    rest = s |> Enum.drop(1)
    do_slices(rest, size, [substr|acc])
  end

end
