defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t], pos_integer) :: map
  def frequency(texts, workers) do
    spawn_workers(texts, workers, 0)
    |> Enum.map(&get_results/1)
    |> Enum.reduce(%{}, &combine_results/2)
  end

  defp spawn_workers([],          _,   _  ), do: []
  defp spawn_workers(_,           max, max), do: raise "Out of workers!"
  defp spawn_workers([text|more], cur, max) do
    caller = self
    [spawn(fn -> analyze(text, caller) end) | spawn_workers(more, cur + 1, max)]
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

  defp get_results(_) do
    receive do
      whatever -> whatever
    end
  end

  defp is_letter?(char) do
    char =~ ~r/^\pL$/u
  end

  defp count_char(char, acc) do
    Map.put(acc, char, Map.get(acc, char, 0) + 1)
  end

  defp combine_results(elt, acc) do
    Map.keys(elt)
    |> Enum.map(&(Map.put(acc,
                          &1,
                          Map.get(acc, &1, 0) + Map.get(elt, &1))))
  end

end
