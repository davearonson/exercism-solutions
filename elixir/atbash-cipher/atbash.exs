defmodule Atbash do
  @doc """
  Encode a given plaintext to the corresponding ciphertext

  ## Examples

  iex> Atbash.encode("completely insecure")
  "xlnko vgvob rmhvx fiv"
  """
  @spec encode(String.t) :: String.t
  def encode(plaintext) do
    letters = "abcdefghijklmnopqrstuvwxyz"
    digits = "0123456789"
    clear = "#{letters}#{digits}"
    cypher = "#{String.reverse(letters)}#{digits}"
    transform = make_transform(String.graphemes(clear),
                               String.graphemes(cypher),
                              %{})
    Regex.scan(~r/[a-zA-Z0-9]/, plaintext |> String.downcase)
    |> Enum.map(&List.first/1)
    |> Enum.map(&(transform[&1]))
    |> Enum.chunk(5, 5, [])
    |> Enum.map(&Enum.join/1)
    |> Enum.join(" ")
  end

  defp make_transform([clear|more_clear], [cypher|more_cypher], acc) do
    make_transform(more_clear, more_cypher, Map.put(acc, clear, cypher))
  end
  defp make_transform([], [], acc), do: acc

end
