defmodule ETL do
  @doc """
  Transform an index into an inverted index.

  ## Examples

  iex> ETL.transform(%{"a" => ["ABILITY", "AARDVARK"], "b" => ["BALLAST", "BEAUTY"]})
  %{"ability" => "a", "aardvark" => "a", "ballast" => "b", "beauty" =>"b"}
  """
  @spec transform(map) :: map
  def transform(input) do
    do_transform(Map.to_list(input), %{})
  end

  defp do_transform([],                    output), do: output
  defp do_transform([{score, words}|rest], output)  do
    do_transform(rest, do_transform_words(score, words, output))
  end

  defp do_transform_words(_,     [],          output), do: output
  defp do_transform_words(score, [word|rest], output)  do
    do_transform_words(score, rest, add_word(output, word, score))
  end

  defp add_word(output, word, score) do
    Map.put(output, String.downcase(word), score)
  end
  
end
