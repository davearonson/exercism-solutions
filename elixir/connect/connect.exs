_comment = """
  IDEA from Glenn Espinosa:
  - Start from desired edge, with desired color
    (eg, from top w/ O, or from left w/ X).
  - See where you can go from there (matching), that we haven't been.
  - For each such place
    * recurse with the current spot added to list of where we've been
  - If we hit opposite side, that color has won
  - If we can't go anywhere, end this exploration;
    automagically goes back to last fork-point
"""
defmodule Connect do
  @doc """
  Calculates the winner (if any) of a board
  using "O" as the white player
  and "X" as the black player
  """
  @spec result_for([String.t]) :: :none | :black | :white
  def result_for(board) do
    grid = board |> Enum.map(&String.graphemes/1)
    cond do
      # use tupleized version for easy cell access/substitution
      connect_to_bottom(tupleize(grid), "O") -> :white
      # transposing saves us the complex logic of
      # figuring out what direction we're going,
      # while figuring out if someone won
      connect_to_bottom(tupleize(transpose(grid)), "X") -> :black
      true -> :none
    end
  end


  defp tupleize(board), do: tupleize(board, {})
  defp tupleize([], acc), do: acc
  defp tupleize([head|tail], acc) do
    tupleize(tail, Tuple.append(acc, head |> List.to_tuple))
  end


  defp connect_to_bottom(board, who) do
    (0..tuple_size(elem(board, 0)) - 1)
    |> Enum.any?(&(connect_to_bottom(board, who, 0, &1)))
  end

  # did we try to go off the board?  no win here.
  defp connect_to_bottom(board, _who, row, col)
       when row < 0 or col < 0 or col >= tuple_size(elem(board, 0)),
       do: false

  # is this spot not this player's, or already seen?  no win here.
  defp connect_to_bottom(board, who, row, col)
       when elem(elem(board, row), col) != who,
       do: false

  # did we reach the bottom?  YAY!
  defp connect_to_bottom(board, _who, row, _col)
       when row == tuple_size(board) - 1,
       do: true

  # if not yet success or failure, try to progress via each surrounding spot.
  # board is tilted, so if we go up we can't go further left,
  # and if we go down, we can't go further right.
  defp connect_to_bottom(board, who, row, col) do
    # "S" could be anything other than empty or a player;
    # making it one char helps debugging via IO.puts :-)
    new_row = elem(board, row) |> put_elem(col, "S")
    new_board = board |> put_elem(row, new_row)
    connect_to_bottom(new_board, who, row + 1, col    ) ||
    connect_to_bottom(new_board, who, row + 1, col - 1) ||
    connect_to_bottom(new_board, who, row    , col - 1) ||
    connect_to_bottom(new_board, who, row    , col + 1) ||
    connect_to_bottom(new_board, who, row - 1, col    ) ||
    connect_to_bottom(new_board, who, row - 1, col + 1)
  end


  defp transpose([head|tail]) do
    transpose(tail, Enum.map(head, &([&1])))
  end
  defp transpose([], acc), do: Enum.map(acc, &Enum.reverse/1)
  defp transpose([head|tail], acc) do
    transpose(tail,
              acc
              |> Enum.zip(head)
              |> Enum.map(fn({old, new}) -> [new|old] end))
  end

end
