defmodule DNA do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> DNA.to_rna('ACTG')
  'UGAC'
  """

  @spec to_rna([char]) :: [char]
  def to_rna(dna) do
    do_to_rna(dna)
  end

  @pairs %{ ?G => ?C, ?C => ?G, ?T => ?A, ?A => ?U }

  defp do_to_rna([]), do: []
  defp do_to_rna([head|rest]), do: [@pairs[head] | do_to_rna(rest)]

end
