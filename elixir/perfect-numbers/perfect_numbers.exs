defmodule PerfectNumbers do
  @doc """
  Determine the aliquot sum of the given `number`, by summing all the factors
  of `number`, aside from `number` itself.

  Based on this sum, classify the number as:

  :perfect if the aliquot sum is equal to `number`
  :abundant if the aliquot sum is greater than `number`
  :deficient if the aliquot sum is less than `number`
  """
  @types [:abundant, :perfect, :deficient]
  @spec classify(number :: integer) :: ({ :ok, atom } | { :error, String.t() })
  def classify(number) when number > 1 do
    with sum <- aliquot_sum(number, :math.sqrt(number), 2, 1),
         sgn <- sign(number - sum) do
      {:ok, @types |> Enum.at(sgn + 1) }
    else
      err -> {:error, err}
    end
  end
  def classify(n) when n < 1, do: { :error, "Classification is only possible for natural numbers." }
  def classify(1), do: {:ok, :deficient}  # special case

  defp aliquot_sum(number, limit, candidate, acc) when candidate <= limit do
    to_add = add_for(number, candidate)
    aliquot_sum(number, limit, candidate + 1, acc + to_add)
  end
  defp aliquot_sum(_, _, _, acc), do: acc

  defp add_for(number, candidate) when rem(number, candidate) != 0, do: 0
  defp add_for(number, candidate) do
    other = number/candidate
    # if other == candidate that's the square root; only add ONCE
    if other == candidate, do: candidate, else: candidate + other
  end

  defp sign(n) when n > 0, do:  1
  defp sign(n) when n < 0, do: -1
  defp sign(_)           , do:  0
end
