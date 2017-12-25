defmodule Minesweeper do

  @doc """
  Annotate empty spots next to mines with the number of mines next to them.
  """
  @spec annotate([String.t]) :: [String.t]

  def annotate(board) do
    # make it a *tuple of rows*, with each a tuple of cells
    # for each row, for each cell, if it's blank,
    # set it to how many neighbors are mines if any.
    tuple_version = board
                    |> Enum.map(&tupleize_string/1)
                    |> List.to_tuple
    board
    |> Enum.with_index
    |> Enum.map(&(annotate_row(&1, tuple_version)))
  end

  defp tupleize_string(str) do
    str |> String.graphemes |> List.to_tuple
  end

  defp annotate_row({row, row_num}, board) do
    row
    |> String.graphemes
    |> Enum.with_index
    |> Enum.map(&(annotate_cell(&1, row_num, board)))
    |> Enum.join
  end

  defp annotate_cell({"*", col_num}, _row_num, _board), do: "*"
  defp annotate_cell({val, col_num},  row_num,  board)  do
    count_neighbors(row_num, col_num, board)
    |> (fn(x) -> if x == 0, do: " ", else: x end).()
  end

  defp count_neighbors(row_num, col_num, board) do
    (-1..1)
    |> Enum.map(&(count_neighbors_in_row(row_num, &1, col_num, board)))
    |> Enum.reduce(&+/2)
  end

  defp count_neighbors_in_row(row_num, row_delta, _col_num, board)
       when row_num + row_delta < 0
         or row_num + row_delta >= tuple_size(board), do: 0
  defp count_neighbors_in_row(row_num, row_delta, col_num, board) do
    (-1..1)
    |> Enum.map(&(check_neighbors_at(row_delta,
                                     col_num, &1,
                                     elem(board, row_num + row_delta))))
    |> Enum.reduce(&+/2)
  end

  defp check_neighbors_at(0,          _col_num, 0,         _row), do: 0
  defp check_neighbors_at(_row_delta,  col_num, col_delta,  row)
       when col_num + col_delta < 0
         or col_num + col_delta >= tuple_size(row), do: 0
  defp check_neighbors_at(_row_delta, col_num, col_delta, row) do
    row
    |> elem(col_num + col_delta)
    |> (fn(x) -> if x == "*", do: 1, else: 0 end).()
  end
end
