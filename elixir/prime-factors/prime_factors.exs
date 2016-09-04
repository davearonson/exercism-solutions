defmodule PrimeFactors do
  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest.
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(number) do
    do_factors_for(2, number, trunc(:math.sqrt(number)), [], []) |> Enum.reverse
  end

  def do_factors_for(_, 1, _, _, acc), do: acc

  def do_factors_for(candidate, number, limit, _, acc) when candidate > limit do
    [number|acc]
  end

  def do_factors_for(candidate, number, limit, primes, acc, known_prime \\ false) do
    if known_prime || is_prime?(candidate, trunc(:math.sqrt(candidate)), primes) do
      # ++ is slow, but we should only have to do it rarely
      primes = if known_prime, do: primes, else: primes ++ [candidate]
      if rem(number, candidate) == 0 do
        new_number = trunc(number/candidate)
        do_factors_for(candidate,
                       new_number,
                       trunc(:math.sqrt(new_number)),
                       primes,
                       [candidate|acc], true)
      else
        do_factors_for(candidate + 1, number, limit, primes, acc)
      end
    else
      do_factors_for(candidate + 1, number, limit, primes, acc)
    end
  end

  def is_prime?(_, limit, [prime|_]) when prime > limit, do: true
  def is_prime?(_, _    , []       )                   , do: true

  def is_prime?(candidate, limit, [prime|more_primes]) do
    case rem(candidate, prime) do
      0 -> false
      _ -> is_prime?(candidate, limit, more_primes)
    end
  end

end
