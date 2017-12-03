defmodule Tournament do
  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input) do
    do_tally(input, %{})
    |> sort_teams
    |> format_results
  end

  defp do_tally([head|tail], acc) do
    do_tally(tail, tally_game(head |> String.split(";"), acc))
  end
  defp do_tally([], acc), do: acc

  defp tally_game([t1, t2, "draw"], acc) do
    acc |> record(t1, "draw") |> record(t2, "draw")
  end
  defp tally_game([t1, t2, "win" ], acc) do
    acc |> record(t1, "win") |> record(t2, "loss")
  end
  defp tally_game([t1, t2, "loss"], acc), do: tally_game([t2, t1, "win"], acc)
  defp tally_game(_anything_else, acc), do: acc

  defp record(acc, team, result) do
    with(old_stats <- get_team_stats(team, acc),
         new_stats <- update_old_stats(old_stats, result)) do
      acc |> Map.put(team, new_stats)
    end
  end

  defp get_team_stats(team, acc) do
    Map.get(acc, team, %{"matches" => 0,
                         "win"     => 0,
                         "draw"    => 0,
                         "loss"    => 0})
  end

  defp update_old_stats(old_stats, result) do
    %{old_stats | "matches" => old_stats["matches"] + 1,
                  result    => old_stats[result] + 1}
  end

  defp sort_teams(teams) do
    teams
    |> Enum.map(&assign_points_and_names/1)
    # note: at this point it's no longer %{nameN => statsN}, but
    # [stats1, stats2, etc.] w/ names and point-totals inside.
    |> Enum.sort(&compare_teams/2)
  end

  @points %{"win" => 3, "draw" => 1}
  defp assign_points_and_names({name, stats}) do
    stats
    |> Map.put("name", name)
    |> Map.put("points", stats["win"] * @points["win"] +
                         stats["draw"] * @points["draw"])
  end

  defp compare_teams(%{"name" => n1, "points"=> p1},
                     %{"name" => n2, "points"=> p2}) do
    cond do
      p1 > p2 -> true
      p1 < p2 -> false
      true    -> n1 < n2
    end
  end

  defp format_results(all_stats) do
    "Team#{String.duplicate(" ", 27)}| MP |  W |  D |  L |  P\n" <>
      (all_stats |> Enum.map(&format_line/1) |> Enum.join("\n"))
  end

  defp format_line(stats) do
    name = stats["name"] |> String.pad_trailing(30)
    matches = stats["matches"] |> pad_num_to(2)
    win = stats["win"] |> pad_num_to(2)
    draw = stats["draw"] |> pad_num_to(2)
    loss = stats["loss"] |> pad_num_to(2)
    points = stats["points"] |> pad_num_to(2)
    "#{name} | #{matches} | #{win} | #{draw} | #{loss} | #{points}"
  end

  defp pad_num_to(num, size) do
    num |> Integer.to_string |> String.pad_leading(size)
  end

end
