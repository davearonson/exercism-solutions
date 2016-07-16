defmodule Anagram do

  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """

  @spec match(String.t, [String.t]) :: [String.t]
  def match(base, candidates) do
    # downcase base just once
    do_match(String.downcase(base), candidates)
  end

  defp do_match(downcased_base, candidates) do
    # sort downcased base letters just once
    do_match_helper(downcased_base, sort_letters(downcased_base), candidates)
  end

  defp do_match_helper(downcased_base, sorted_base, candidates) do
    candidates |> Enum.filter(&is_a_match(&1,
                                          String.downcase(&1),
                                          downcased_base,
                                          sorted_base))
  end

  # don't bother sorting candidate unless needed; see other def
  defp is_a_match(_, downcased_base, downcased_base, _), do: false

  defp is_a_match(candidate, downcased_candidate, _, sorted_base) do
    letters_match(candidate, sort_letters(downcased_candidate), sorted_base)
  end

  defp letters_match(candidate, sorted_base, sorted_base), do: candidate

  defp letters_match(_, _, _), do:  false

  defp sort_letters(str), do: str |> String.split("") |> Enum.sort |> Enum.join

end
