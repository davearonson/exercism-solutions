defmodule Sieve do

  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(limit) do
    do_primes_to(limit, 2, %{})
    |> Enum.filter(&(elem(&1, 1)))
    |> Enum.map(&(elem(&1, 0)))
    |> Enum.sort
  end

  defp do_primes_to(limit, candidate, numbers) when candidate > limit do
    numbers
  end

  defp do_primes_to(limit, candidate, numbers) do
    next_numbers = if numbers[candidate] == false do  # known composite
                     numbers
                   else
                     # kinda cheating here -- instead of leaving the primes
                     # unmarked, I'm marking them in a different way.  could
                     # instead have put the marked ones in a set and subtracted
                     # them from a map of all or some such; this way just uses
                     # the same map to keep track of both.
                     mark_multiples(Map.put(numbers, candidate, true),
                                    candidate * 2,
                                    candidate,
                                    limit)
                   end
    do_primes_to(limit, candidate + 1, next_numbers)
  end

  defp mark_multiples(numbers, this_one, _, limit) when this_one > limit do
    numbers
  end

  defp mark_multiples(numbers, this_one, candidate, limit) do
    mark_multiples(Map.put(numbers, this_one, false),
                   this_one + candidate,
                   candidate,
                   limit)
  end

end
