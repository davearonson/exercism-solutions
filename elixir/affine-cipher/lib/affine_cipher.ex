defmodule AffineCipher do
  @typedoc """
  A type for the encryption key
  """
  @type key() :: %{a: integer, b: integer}

  @doc """
  Encode an encrypted message using a key
  """
  @spec encode(key :: key(), message :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def encode(%{a: a, b: b}, message) do
    if coprime_with_26(a) do
      encoded =
        message
        |> String.graphemes
        |> Enum.map(&(encode_char(&1, a, b)))
        |> Enum.filter(&(&1))
        |> Enum.chunk_every(5)
        |> Enum.map(&List.to_string/1)
        |> Enum.join(" ")
      {:ok, encoded}
    else
      {:error, "a and m must be coprime."}
    end
  end

  defp coprime_with_26(x), do: rem(x, 2) != 0 && rem(x, 13) != 0

  defp encode_char(char, a, b) do
    <<ascii>> = String.downcase(char)
    cond do
      ascii in (?a..?z) -> rem((ascii - ?a) * a + b, 26) + ?a
      ascii in (?0..?9) -> ascii
      true              -> nil
    end
  end

  @doc """
  Decode an encrypted message using a key
  """
  @spec decode(key :: key(), message :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def decode(%{a: a, b: b}, encrypted) do
    if coprime_with_26(a) do
      mmi = find_mmi(a, 1)
      clear =
        encrypted
        |> String.graphemes
        |> Enum.map(&(decode_char(&1, mmi, b)))
        |> Enum.filter(&(&1))
        |> List.to_string
      {:ok, clear}
    else
      {:error, "a and m must be coprime."}
    end
  end

  defp find_mmi(a, 26),
    do: raise ArgumentError, message: "Can't find an MMI for #{a}"
  defp find_mmi(a, cand),
    do: if rem(a * cand, 26) == 1, do: cand, else: find_mmi(a, cand + 1)

  defp decode_char(char, mmi, b) do
    <<ascii>> = String.downcase(char)
    cond do
      # use Integer.mod as it will not return negative
      ascii in (?a..?z) -> Integer.mod(mmi * (ascii - ?a - b), 26) + ?a
      ascii in (?0..?9) -> ascii
      true              -> nil
    end
  end
end
