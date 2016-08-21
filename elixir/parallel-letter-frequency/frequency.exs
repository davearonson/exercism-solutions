defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t], pos_integer) :: map
  def frequency(texts, workers) do
    do_frequency(texts, workers)
  end

  defp do_frequency(texts, workers) do
    texts
    |> Enum.flat_map(&(String.split(&1, "\n")))
    |> split_among(workers, 0, {})
    |> spawn_workers(self, [])
    |> Enum.map(&get_results/1)
    |> Enum.reduce(%{}, &combine_results/2)
  end

  defp split_among([], _, _, acc), do: Tuple.to_list(acc)

  defp split_among([hd|tl], workers, cur, acc) when tuple_size(acc) < workers do
    split_among(tl, workers, rem(cur + 1, workers), Tuple.append(acc, [hd]))
  end

  defp split_among([hd|tl], workers, cur, acc) do
    split_among(tl,
                workers,
                rem(cur + 1, workers),
                put_elem(acc, cur, [hd | elem(acc, cur)]))
  end

  defp spawn_workers([], _, acc), do: acc
  defp spawn_workers([lines|more], caller, acc) do
    spawn_workers(more, caller, [spawn(fn -> analyze(lines, caller) end) | acc])
  end

  defp analyze(lines, caller) do
    send(caller,
         lines
         |> Enum.join
         |> String.downcase
         |> get_letters
         |> Enum.reduce(%{}, &count_char/2))
  end

  defp get_letters(text) do
    Regex.scan(~r/\pL/u, text) |> List.flatten
  end

  defp count_char(char, acc) do
    Map.put(acc, char, Map.get(acc, char, 0) + 1)
  end

  defp get_results(_) do
    receive do
      whatever -> whatever
    end
  end

  defp combine_results(elt, acc) do
    Map.merge(elt, acc, fn _k, v1, v2 -> v1 + v2 end)
  end

end
