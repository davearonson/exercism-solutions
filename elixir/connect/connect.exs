"""
  IDEA from Glenn Espinosa:
  - Start from desired edge, with desired color
    (eg, from top w/ O, or from left w/ X).
  - See where you can go from there (matching), that we haven't been.
  - For each such place
    * recurse with the current spot added to list of where we've been
  - If we hit opposite side, that color has won
  - If we can't go anywhere, end this exploration;
    automagically goes back to last fork-point

    Now, where is it we CAN go from x,y?
    Obviously left and right (x +/- 1, y).
    Directly up (x,y-1), and up-right (x+1, y-1),
    directly down (x,y+1), and down-LEFT (x-1, y+1).
    (Using y-coord as typical of computer graphics,
    where 0 is top, not math, where it's bottom.)

    Much more efficient if we first make it all a tuple of tuples.  :-)
"""
defmodule Connect do
  @doc """
  Calculates the winner (if any) of a board
  using "O" as the white player
  and "X" as the black player
  """
  @spec result_for([String.t]) :: :none | :black | :white
  def result_for(board) do
    cond do
      can_connect(tuplize(board), "X") -> :black
      can_connect(tuplize(transpose(board)), "O") -> :white
      true -> :none
    end
  end


  def tuplize(board), do: tuplize(board, {})
  def tuplize([], acc), do: acc
  def tuplize([head|tail], acc) do
    tuplize(tail, Tuple.append(acc, List.to_tuple(head)))
  end

  defp can_connect(board, who) do
    # TODO:
    # starting from each point held by this player,
    # on the top row of the board,
    # try to trace a path to the bottom row,
    # through each legit move to a spot held by the same player,
    # that we have not yet seen.
  end

  def transpose([head|tail]) do
    transpose(tail, Enum.map(head, &([&1])))
  end
  def transpose([], acc), do: Enum.map(acc, &Enum.reverse/1)
  def transpose([head|tail], acc) do
    transpose(tail,
              acc
              |> Enum.zip(head)
              |> Enum.map(fn({old, new}) -> [new|old] end))
  end

end
