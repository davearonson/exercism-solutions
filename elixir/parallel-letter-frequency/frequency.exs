defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t], pos_integer) :: map
  def frequency(texts, workers) do
    texts
    |> Enum.join("\n")
    |> Enum.split("\n")  # so we wind up with a big array of lines to split up
    |> break_up(workers, 0, {})
    |> spawn_workers(self, [])
    |> Enum.map(&get_results/1)
    |> Enum.reduce(%{}, &combine_results/2)
  end

  defp break_up([], _, _, acc), do: Tuple.to_list(acc)

  defp break_up([text|more], workers, cur, acc) where cur < workers do
    break_up(more, workers, cur + 1, Tuple.append(acc, text))
  end

  defp break_up([text|more], workers, cur, acc) do
    break_up(more,
             workers,
             rem(cur+1, workers),
             put_elem(acc, cur, elem(acc, cur) <> text))
  end

  defp spawn_workers([], caller, acc), do: acc
  defp spawn_workers([text|more], caller, acc) do
    spawn_workers(more, [spawn(fn -> analyze(text, caller) end) | acc])
  end

  defp analyze(text, caller) do
    send(caller,
         text
         |> String.downcase
         |> String.graphemes
         |> Enum.filter(&is_letter?/1)
         |> Enum.reduce(%{}, &count_char/2)
   )
  end

  defp is_letter?(char) do
    char =~ ~r/^\pL$/u
  end

  defp count_char(char, acc) do
    Map.put(acc, char, Map.get(acc, char, 0) + 1)
  end

  defp get_results(_) do
    receive do
      whatever -> whatever
    end
  end

  # LEFT OFF HERE: THIS IS DEFINITELY WRONG, NEEDS WORK!
  defp combine_results(elt, acc) do
    Map.keys(elt)
    |> Enum.map(&(Map.put(acc,
                          &1,
                          Map.get(acc, &1, 0) + Map.get(elt, &1))))
  end

end
