defmodule Prime do

  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  # we COULD handle 0 with this implementation, but test says raise error
  def nth(count) when count <= 0, do: raise ArgumentError
  def nth(count) do
    List.last(primes_list(count, [], 2))
  end

  # Tradeoffs:
  #
  # - Could have not bothered caching the primes we've found so far, and just
  # counted them... but then we'd have to check ALL numbers up to the limit to
  # see if the current candidate is a multiple, not just the primes, which are
  # a small subset.
  #
  # - Could have PREpended to the "primes so far" list, and taken the FIRST one
  # instead of the last in nth, and reversed before the take_while... but even
  # though appending and taking the last are far less efficient, the former
  # happens only on primes and the latter happens only once, but they let us
  # skip the reversal at *every* step.
  #
  # - Could have gotten the numbers as a Stream.  That was in fact what I first
  # tried.  But it made other things more complex, assuming I wanted to still
  # cache the "primes so far" list.

  def primes_list(how_many, primes_so_far, candidate) do
    cond do
      Enum.count(primes_so_far) == how_many ->
        primes_so_far
      any_factors(primes_so_far, candidate) ->
        primes_list(how_many, primes_so_far, candidate + 1)
      true ->
        primes_list(how_many, primes_so_far ++ [candidate], candidate + 1)
    end
  end

  defp any_factors(primes_so_far, candidate) do
    primes_so_far
    |> Enum.take_while(&(&1 <= :math.sqrt(candidate)))
    |> Enum.any?(&(is_multiple?(&1, candidate)))
  end
  
  defp is_multiple?(factor, multiple) do
    rem(multiple, factor) == 0
  end

end

