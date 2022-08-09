defmodule StateOfTicTacToe do
  @doc """
  Determine the state a game of tic-tac-toe where X starts.
  """
  @spec game_state(board :: String.t()) :: {:ok, :win | :ongoing | :draw} | {:error, String.t()}
  def game_state(board) do
    parsed =
      board
      |> String.trim
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)
    invalid?(parsed) || good_state(parsed)
  end

  defp invalid?(parsed) do
    plays =
      parsed
      |> List.flatten
      |> Enum.filter(&(&1 == "X" or &1 == "O"))
    xs = Enum.count(plays, &(&1 == "X"))
    os = Enum.count(plays, &(&1 == "O"))
    reason =
      cond do
        win?(parsed, "X") and win?(parsed, "O") ->
          "Impossible board: game should have ended after the game was won"
        xs < os ->
          "Wrong turn order: O started"
        xs > os + 1 ->
          "Wrong turn order: X went twice"  # or more
        # There are a LOT of possible invalid states not covered here!
        true ->
          nil
      end
    if reason, do: {:error, reason}, else: false
  end

  defp good_state(parsed) do
    cond do
      win?(parsed)            -> {:ok, :win}
      not space_left?(parsed) -> {:ok, :draw}
      true                    -> {:ok, :ongoing}
    end
  end

  defp space_left?([[h1|t1]|t2]), do: h1 == "." or space_left?([t1|t2])
  defp space_left?([[]|t2]), do: space_left?(t2)
  defp space_left?([]), do: false

  # tempted to make this more generic, but for definite 3x3, YAGNI
  defp win?([[a,b,c],[d,e,f],[g,h,i]], who \\ nil) do
    same?(a, b, c, who) or same?(d, e, f, who) or same?(g, h, i, who) or
    same?(a, d, g, who) or same?(b, e, h, who) or same?(c, f, i, who) or
    same?(a, e, i, who) or same?(c, e, g, who)
  end

  defp same?(".",   _,   _,   _), do: false
  defp same?(ltr, ltr, ltr, nil), do: true
  defp same?(ltr, ltr, ltr, ltr), do: true
  defp same?(  _,   _,   _,   _), do: false
end
