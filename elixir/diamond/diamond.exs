defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t
  def build_shape(letter) do
    quarter = (?A..letter) |> Enum.map(&(make_quarter_line(&1, letter)))
    quarter_reversed = quarter |> Enum.map(&String.reverse/1)
                               |> Enum.map(&(String.slice(&1, 1..-1)))
    top_half = quarter |> Enum.zip(quarter_reversed)
                       |> Enum.map(&("#{elem(&1,0)}#{elem(&1,1)}"))
    bottom_half = top_half |> Enum.reverse |> Enum.drop(1)
    (top_half ++ bottom_half ++ [""]) |> Enum.join("\n")
  end

  defp make_quarter_line(cur, max) do
    <<cur::utf8>> |> String.pad_leading(max + 1 - cur)
                  |> String.pad_trailing(max + 1 - ?A)
  end

end
