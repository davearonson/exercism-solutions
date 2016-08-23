defmodule DNA do
  @doc """
  Returns number of differences between two strands of DNA, known as the Hamming Distance.

  ## Examples

  iex> DNA.hamming_distance('AAGTCATA', 'TAGCGATC')
  4
  """
  @spec hamming_distance([char], [char]) :: non_neg_integer
  def hamming_distance(strand1, strand2) do
    do_distance(strand1, strand2, 0)
  end

  defp do_distance([h|t1], [h|t2], acc), do: do_distance(t1, t2, acc)
  defp do_distance([_|t1], [_|t2], acc), do: do_distance(t1, t2, acc + 1)
  defp do_distance([],     [],     acc), do: acc
  defp do_distance(_,      _,      _  ), do: nil
end
