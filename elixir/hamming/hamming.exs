defmodule DNA do
  @doc """
  Returns number of differences between two strands of DNA, known as the Hamming Distance.

  ## Examples

  iex> DNA.hamming_distance('AAGTCATA', 'TAGCGATC')
  {:ok, 4}
  """

  @spec hamming_distance([char], [char]) :: non_neg_integer
  def hamming_distance(strand1, strand2) do
    do_hamming_distance(strand1, strand2, 0)
  end

  defp do_hamming_distance([head1|rest1], [head1|rest2], count_so_far) do
    do_hamming_distance(rest1, rest2, count_so_far)
  end

  defp do_hamming_distance([_head1|rest1], [_head2|rest2], count_so_far) do
    do_hamming_distance(rest1, rest2, count_so_far + 1)
  end

  defp do_hamming_distance([], [], count_so_far), do: { :ok, count_so_far }

  defp do_hamming_distance(_, _, _) do
    { :error, "Lists must be the same length." }
  end

end
