defmodule Anagram do

  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """

  @spec match(String.t, [String.t]) :: [String.t]
  def match(base, candidates) do
    candidates |> Enum.filter(&is_anagram?(String.downcase(&1),
                                           String.downcase(base)))
  end

  defp is_anagram?(base, base), do: false

  defp is_anagram?(candidate, base) do
    sort_letters(candidate) == sort_letters(base)
  end

  defp sort_letters(str), do: str |> String.split("") |> Enum.sort

end
