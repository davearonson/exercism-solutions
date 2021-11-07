defmodule WineCellar do
  def explain_colors do
    [white: "Fermented without skin contact.",
     red:   "Fermented with skin contact using dark-colored grapes.",
     rose:  "Fermented with some skin contact, but not enough to qualify as a red wine."]
  end

  def filter(cellar, color, opts \\ []) do
    Keyword.get_values(cellar, color)
    |> filter_by(opts[:year], 1)
    |> filter_by(opts[:country], 2)
  end

  defp filter_by(wines, nil , _position), do: wines
  defp filter_by(wines, want, position) do
    wines
    |> Enum.filter(fn(wine) -> elem(wine, position) == want end)
  end

  # The functions below do not need to be modified.
  # BUT WE CAN JUST IGNORE THEM, hahahahaha!  -dja  ;-)

  defp filter_by_year(wines, year)
  defp filter_by_year([], _year), do: []

  defp filter_by_year([{_, year, _} = wine | tail], year) do
    [wine | filter_by_year(tail, year)]
  end

  defp filter_by_year([{_, _, _} | tail], year) do
    filter_by_year(tail, year)
  end

  defp filter_by_country(wines, country)
  defp filter_by_country([], _country), do: []

  defp filter_by_country([{_, _, country} = wine | tail], country) do
    [wine | filter_by_country(tail, country)]
  end

  defp filter_by_country([{_, _, _} | tail], country) do
    filter_by_country(tail, country)
  end
end
