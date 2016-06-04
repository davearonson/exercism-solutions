# BUG: Sublist.compare([1, 2, 1, 2, 3], [1, 2, 3, 1, 2, 3, 2, 3, 2, 1])
# return :sublist, should be :unequal

defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare(a, b) do
    do_compare(a, b)
  end

  defp do_compare(a, b) do
    cond do
      a === b -> :equal
      is_sublist?(a, b) -> :sublist
      is_sublist?(b, a) -> :superlist
      true -> :unequal
    end
  end

  defp is_sublist?(needle, haystack) do
    cond do
      length(haystack) < length(needle) -> false
      starts_with?(haystack, needle) -> true
      true -> is_sublist?(needle, tl(haystack))
    end
  end

  defp starts_with?(_, []), do: true
  defp starts_with?([], _), do: false
  defp starts_with?(haystack, needle) do
    hd(needle) === hd(haystack) && starts_with?(tl(haystack), tl(needle))
  end
    
end
