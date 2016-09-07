defmodule Atbash do
  @doc """
  Encode a given plaintext to the corresponding ciphertext

  ## Examples

  iex> Atbash.encode("completely insecure")
  "xlnko vgvob rmhvx fiv"
  """
  @spec encode(String.t) :: String.t
  def encode(plaintext) do
    Regex.scan(~r/[a-zA-Z0-9]/, plaintext |> String.downcase)
    |> Enum.map(&List.first/1)
    |> Enum.map(&(transform(&1)))
    |> Enum.chunk(5, 5, [])
    |> Enum.map(&Enum.join/1)
    |> Enum.join(" ")
  end

  defp transform(char) do
    cond do
      Regex.match?(~r/[a-z]/, char) ->
        [?z + ?a - (char |> to_charlist |> List.first)]
      Regex.match?(~r/[0-9]/, char) ->
        char
      true ->
        IO.puts "Transforming #{inspect char}"
        raise ArgumentError
    end
  end

end
