defmodule Matrix do
  @doc """
  Parses a string representation of a matrix
  to a list of rows
  """
  @spec rows(String.t()) :: [[integer]]
  def rows(str) do
    str
    |> String.split("\n")
    |> Enum.map(&String.split/1)
    |> Enum.map(&array_of_strings_to_ints/1)
  end

  defp array_of_strings_to_ints(arr) do
    do_array_of_strings_to_ints(arr, []) |> Enum.reverse
  end

  defp do_array_of_strings_to_ints([], acc), do: acc
  defp do_array_of_strings_to_ints([str|more], acc) do
    do_array_of_strings_to_ints(more, [String.to_integer(str)|acc])
  end

  @doc """
  Parses a string representation of a matrix
  to a list of columns
  """
  @spec columns(String.t()) :: [[integer]]
  def columns(str) do
    rows(str) |> List.zip |> Enum.map(&Tuple.to_list/1)
  end

  @doc """
  Calculates all the saddle points from a string
  representation of a matrix
  """
  @spec saddle_points(String.t()) :: [{integer, integer}]
  def saddle_points(str) do
    MapSet.intersection(find_candidates(rows(str),
                                        &Enum.max/1,
                                        &itself/1),
                        # would more efficient to derive from memoized rows
                        find_candidates(columns(str),
                                        &Enum.min/1,
                                        &reverse_tuple/1))
    |> MapSet.to_list
  end

  # "view" meaning, the array of arrays, be it by rows or columns
  defp find_candidates(view, extreme_finder, loc_maker) do
    view |> Enum.with_index
         |> Enum.flat_map(&(make_extreme_locs(&1,
                                              extreme_finder,
                                              loc_maker)))
         |> Enum.into(%MapSet{})
  end

  defp make_extreme_locs(list_with_index, extreme_finder, loc_maker) do
    # assignments just to memoize and simplify....
    vals = elem(list_with_index, 0)
    extreme = apply(extreme_finder, [vals])
    list_num = elem(list_with_index, 1)
    vals |> Enum.with_index
         |> Enum.filter(&(elem(&1, 0) == extreme))
         |> Enum.map(&(apply(loc_maker, [{list_num, elem(&1, 1)}])))

  end

  defp itself(whatever), do: whatever

  defp reverse_tuple({col, row}), do: {row, col}

end
