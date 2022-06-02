defmodule KillerSudokuHelper do
  @doc """
  Return the possible combinations of `size` distinct numbers from 1-9 excluding `exclude` that sum up to `sum`.
  """
  @spec combinations(cage :: %{exclude: [integer], size: integer, sum: integer}) :: [[integer]]
  def combinations(%{exclude: [], size: 1, sum: sum}), do: [[sum]]

  def combinations(cage) do
    ok_digits = Enum.to_list(1..9) -- cage[:exclude]
    do_combos(cage[:size], cage[:sum], ok_digits, [])
  end

  defp do_combos(0,      0, _ok_digits,  combo), do: Enum.reverse(combo)
  defp do_combos(0,      _, _ok_digits, _combo), do: []
  defp do_combos(_,    sum, _ok_digits, _combo)  when sum <= 0, do: []
  defp do_combos(_,      _,         [], _combo), do: []
  defp do_combos(size, sum,  ok_digits,  combo)  do
    ok_digits
    |> Enum.map(&(do_combos(size - 1,
                            sum - &1,
                            drop_thru(ok_digits, &1),
                            [&1 | combo])))
    |> Enum.reject(&(&1 == []))
    |> Enum.map(&unwrap_list/1)
  end

  defp drop_thru([ digit|more],  digit), do: more
  defp drop_thru([_digit|more], target), do: drop_thru(more, target)
  defp unwrap_list([list]) when is_list(list), do: list
  defp unwrap_list(non_list), do: non_list
end
