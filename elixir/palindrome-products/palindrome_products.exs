defmodule Palindromes do

  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: map
  def generate(max_factor, min_factor \\ 1) do
    do_generate(min_factor, min_factor, max_factor + 1, %{})
  end

  defp do_generate(too_high, _, too_high, acc), do: acc

  defp do_generate(cur1, too_high, too_high, acc), do:
    do_generate(cur1 + 1, cur1 + 1, too_high, acc)

  defp do_generate(cur1, cur2, too_high, acc) do
    do_generate(cur1, cur2 + 1, too_high,
                revise_accumulator(cur1, cur2, acc))
  end

  defp revise_accumulator(cur1, cur2, acc) do
    product = cur1 * cur2
    if palindrome?(Integer.to_string(product)) do
      Map.put(acc, product, [[cur1, cur2] | Map.get(acc, product, [])])
    else
      acc
    end
  end

  defp palindrome?(str), do: String.reverse(str) == str

end
