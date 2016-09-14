defmodule Triplet do

  @doc """
  Calculates sum of a given triplet of integers.
  """
  @spec sum([non_neg_integer]) :: non_neg_integer
  def sum(triplet) do
    triplet |> Enum.reduce(&+/2)
  end

  @doc """
  Calculates product of a given triplet of integers.
  """
  @spec product([non_neg_integer]) :: non_neg_integer
  def product(triplet) do
    triplet |> Enum.reduce(&*/2)
  end

  @doc """
  Determines if a given triplet is pythagorean. That is, do the squares of a and b add up to the square of c?
  """
  @spec pythagorean?([non_neg_integer]) :: boolean
  def pythagorean?([a, b, c]) do
    a * a + b * b == c * c
  end

  @doc """
  Generates a list of pythagorean triplets from a given min (or 1 if no min) to a given max.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: [list(non_neg_integer)]
  def generate(min, max) do
    low = trunc(:math.sqrt(min * 2))  # inverse of min*min/2
    # not sure if this is high enough really; the math makes my head hurt
    high = max * :math.sqrt(2)
    # feed it only even current-numbers
    do_generate(min, low + rem(low, 2), max, high, [])
  end

  defp do_generate(_  , cur, _  , high, acc) when cur > high, do: acc
  defp do_generate(min, cur, max, high, acc) do
    # yeah, ++ is kinda slow... but to avoid this
    # we'd have to pass the acc all the way down,
    # and tack on each dicksonized factoring, yuck!
    do_generate(min, cur+2, max, high, acc ++ dicksons_triples(min, cur, max))
  end

  # triples generated with dickson's method; see
  # https://en.wikipedia.org/wiki/Formulas_for_generating_Pythagorean_triples#Dickson.27s_method
  # method chosen because "All Pythagorean triples may be found by this method."
  # whereas other methods only find certain families.
  defp dicksons_triples(min, cur, max) do
    factorings(trunc(cur * cur / 2))
    |> Enum.map(&(dicksonize(cur, &1)))
    |> Enum.filter(&(all_within?(&1, min, max)))
  end

  defp factorings(num) do
    # this gives us no dups, and in sorted order
    (1..trunc(:math.sqrt(num)))
    |> Enum.filter(&(rem(num, &1)) == 0)
    |> Enum.map(&([&1, trunc(num/&1)]))
  end

  defp dicksonize(r, [s,t]) do
    [r+s, r+t, r+s+t]
  end

  defp all_within?([n|rest], min, max) do
    n <= max && n >= min && all_within?(rest, min, max)
  end
  defp all_within?([], _, _), do: true

  @doc """
  Generates a list of pythagorean triplets from a given min to a given max, whose values add up to a given sum.
  """
  @spec generate(non_neg_integer, non_neg_integer, non_neg_integer) :: [list(non_neg_integer)]
  def generate(min, max, sum) do
    generate(min, max) |> Enum.filter(&(Enum.sum(&1) == sum))
  end
end
