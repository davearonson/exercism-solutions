defmodule ProteinTranslation do
  @doc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: { atom,  list(String.t()) }

  def of_rna(rna) do
    { ok, reversed_peptides } = do_of_rna(rna, [])
    cond do
      ok == :error -> { :error, "invalid RNA" }
      true         -> { :ok, reversed_peptides |> Enum.reverse }
    end
  end

  def do_of_rna("",     acc), do: { :ok, acc }
  def do_of_rna(strand, acc)  do
    { codon, rest } = strand |> String.split_at(3)
    { ok, peptide } = of_codon(codon)
    cond do
      ok == :error      -> { :error, "invalid codon" }
      peptide == "STOP" -> { :ok, acc }
      true              -> do_of_rna(rest, [peptide|acc])
    end
  end

  @doc """
  Given a codon, return the corresponding protein

  UGU -> Cysteine
  UGC -> Cysteine
  UUA -> Leucine
  UUG -> Leucine
  AUG -> Methionine
  UUU -> Phenylalanine
  UUC -> Phenylalanine
  UCU -> Serine
  UCC -> Serine
  UCA -> Serine
  UCG -> Serine
  UGG -> Tryptophan
  UAU -> Tyrosine
  UAC -> Tyrosine
  UAA -> STOP
  UAG -> STOP
  UGA -> STOP
  """

  @proteins %{
    "UGU" => "Cysteine",
    "UGC" => "Cysteine",
    "UUA" => "Leucine",
    "UUG" => "Leucine",
    "AUG" => "Methionine",
    "UUU" => "Phenylalanine",
    "UUC" => "Phenylalanine",
    "UCU" => "Serine",
    "UCC" => "Serine",
    "UCA" => "Serine",
    "UCG" => "Serine",
    "UGG" => "Tryptophan",
    "UAU" => "Tyrosine",
    "UAC" => "Tyrosine",
    "UAA" => "STOP",
    "UAG" => "STOP",
    "UGA" => "STOP",
  }
  
  @codons @proteins |> Map.keys

  @spec of_codon(String.t()) :: { atom, String.t() }
  def of_codon(codon) when codon in @codons, do: { :ok, @proteins[codon] }
  def of_codon(_),                           do: { :error, "invalid codon" }

end
