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
    rows = rows(str)
    columns = columns(str)  # more efficient to derive from rows, but....
    row_maxes = find_candidates(rows, &find_max/1)
    IO.puts "\nrow_maxes = #{inspect row_maxes}"
    col_mins = find_candidates(columns, &find_min/1)
    IO.puts "\ncol_mins = #{inspect col_mins}"
    MapSet.intersection(col_mins, row_maxes) |> MapSet.to_list
  end

  defp find_candidates(metalist, extreme_finder) do
    metalist |> Enum.with_index
             |> Enum.map(extreme_finder)
             |> List.flatten
             |> Enum.into(%MapSet{})
  end

  defp find_max({row, row_num}) do
    val = Enum.max(row)
    row |> Enum.with_index
        |> Enum.filter(&(elem(&1, 0) == val))
        |> Enum.map(&({row_num, elem(&1, 1)}))
  end

  defp find_min({col, col_num}) do
    val = Enum.min(col)
    col |> Enum.with_index
        |> Enum.filter(&(elem(&1, 0) == val))
        |> Enum.map(&({elem(&1, 1), col_num}))
  end

end
