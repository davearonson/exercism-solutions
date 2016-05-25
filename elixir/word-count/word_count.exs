defmodule Words do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """

  @spec count(String.t) :: map()
  def count(sentence) do
    do_count(%{}, List.flatten(Regex.scan(~r/[[:alpha:][:digit:]\-]+/iu,
                                          String.downcase(sentence))))
  end


  defp do_count(acc, []), do: acc

  defp do_count(acc, [""|tail]), do: acc |> do_count(tail)

  defp do_count(acc, [head|tail]) do
    acc |> update_word(head) |> do_count(tail)
  end


  defp update_word(acc, word) do
    Map.put(acc, word, Map.get(acc, word, 0) + 1)
  end

end
