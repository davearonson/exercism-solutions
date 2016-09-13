defmodule CryptoSquare do
  @doc """
  Encode string square methods
  ## Examples

    iex> CryptoSquare.encode("abcd")
    "ac bd"
  """
  @spec encode(String.t) :: String.t
  def encode(""), do: ""
  def encode(str) do
    chars = Regex.scan(~r/[a-zA-Z0-9]/, str |> String.downcase)
    {_, cols} = best_size(length(chars))
    chars
    |> Enum.map(&List.first/1)
    |> Enum.chunk(cols, cols, [])
    |> zip_all
    |> Enum.map(&Enum.join/1)
    |> Enum.join(" ")
  end

  # could start at {1,1}, but this lets us skip past
  # solutions that are obviously too small
  defp best_size(len) do
    root = trunc(:math.sqrt(len))
    best_size(len, {root,root})
  end
  defp best_size(len, {rows, cols}) when rows * cols >= len, do: {rows, cols}
  defp best_size(len, {rows, rows}), do: best_size(len, {rows , rows+1})
  defp best_size(len, {rows, cols}), do: best_size(len, {rows+1, cols})

  defp zip_all([next|rest]), do: zip_all(rest, next)
  defp zip_all([]         , acc), do: acc
  defp zip_all([next|rest], acc), do: zip_all(rest, my_zip(acc, next))

  # normal zip stops at the first empty one, and this one doesn't,
  # plus it skips the conversion from nested tuples to one list.
  defp my_zip(one    , two    , acc \\ [])
  defp my_zip([]     , []     , acc), do: acc |> Enum.reverse
  defp my_zip([h1|t1], [h2|t2], acc), do: my_zip(t1, t2, [[h1,h2]|acc])
  defp my_zip([h1|t1], []     , acc), do: my_zip(t1, [], [h1|acc])
  # don't need a "first list is empty" clause in this exercise

end
