defmodule DNA do
  @nucleotides [?A, ?C, ?G, ?T]

  @doc """
  Counts individual nucleotides in a DNA strand.

  ## Examples

  iex> DNA.count('AATAA', ?A)
  4

  iex> DNA.count('AATAA', ?T)
  1
  """
  @spec count([char], char) :: non_neg_integer
  def count(strand, nucleotide) do
    do_count(strand, nucleotide)
  end

  defp do_count([         ],    _), do: 0
  defp do_count([char|rest], char), do: do_count(rest, char) + 1
  defp do_count([_   |rest], char), do: do_count(rest, char)


  @doc """
  Returns a summary of counts by nucleotide.

  ## Examples

  iex> DNA.nucleotide_counts('AATAA')
  %{?A => 4, ?T => 1, ?C => 0, ?G => 0}
  """
  @spec nucleotide_counts([char]) :: Dict.t
  def nucleotide_counts(strand) do
    do_nucleotide_counts(strand)
  end

  defp do_nucleotide_counts([]), do: %{?A => 0, ?T => 0, ?C => 0, ?G => 0}

  defp do_nucleotide_counts([head|rest]) do
    Map.update(do_nucleotide_counts(rest), head, 0, &(&1 + 1))
  end

end
