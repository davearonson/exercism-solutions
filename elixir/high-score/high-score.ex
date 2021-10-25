defmodule HighScore do

  @no_score_yet 0

  def new(), do: %{}

  def add_player(scores, name, score \\ @no_score_yet), do: Map.put(scores, name, score)

  def remove_player(scores, name), do: Map.delete(scores, name)

  def reset_score(scores, name), do: Map.put(scores, name, @no_score_yet)

  def update_score(scores, name, score) do
    Map.update(scores, name, score, fn(old) -> score + old end)
  end

  def get_players(scores), do: Map.keys(scores)
end
