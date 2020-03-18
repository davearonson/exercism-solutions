defmodule Spiral do
  @doc """
  Given the dimension, return a square matrix of numbers in clockwise spiral order.
  """
  @spec matrix(dimension :: integer) :: list(list(integer))
  def matrix(0), do: []
  def matrix(n)  do
    zeroes =
      List.duplicate(0, n)
      |> List.to_tuple
      |> List.duplicate(n)
      |> List.to_tuple
    spiral(zeroes, n, 0, 0, :right, 1)
  end

  defp spiral(nums, size, _row, _col, _dir, so_far) when so_far > size*size do
    nums
    |> Tuple.to_list
    |> Enum.map(&Tuple.to_list/1)
  end

  defp spiral(nums, size, row, col, dir, so_far) do
    new_nums = update_matrix(nums, row, col, so_far)
    [new_row, new_col, new_dir] = next_nav(new_nums, size, row, col, dir)
    spiral(new_nums, size, new_row, new_col, new_dir, so_far + 1)
  end

  defp update_matrix(nums, row, col, so_far) do
    put_elem(nums, row, put_elem(elem(nums, row), col, so_far))
  end

  defp next_nav(nums, size, row, col, dir) do
    [new_row, new_col] = next_in_line(row, col, dir)
    if past_limit(new_row, new_col, size, dir) or
       occupied(nums, new_row, new_col) do
      new_dir = right_turn(dir)
      # yes ++ is frowned on but we know this list is very small so OK
      next_in_line(row, col, new_dir) ++ [new_dir]
    else
      [new_row, new_col, dir]
    end
  end

  @row_deltas  %{ right: 0, down: 1, left:  0, up: -1 }
  @col_deltas  %{ right: 1, down: 0, left: -1, up:  0 }
  defp next_in_line(row, col, dir) do
    [row + @row_deltas[dir], col + @col_deltas[dir]]
  end

  defp past_limit(  -1, _col, _size, :up   ), do: true
  defp past_limit(size, _col,  size, :down ), do: true
  defp past_limit(_row,   -1, _size, :left ), do: true
  defp past_limit(_row, size,  size, :right), do: true
  defp past_limit(_row, _col, _size, _dir  ), do: false

  defp occupied(nums, row, col) do
    elem(elem(nums, row), col) > 0
  end

  @next_dirs  %{ right: :down, down: :left, left: :up, up: :right }
  defp right_turn(dir), do: @next_dirs[dir]

end
