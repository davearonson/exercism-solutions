defmodule BoutiqueSuggestions do
  def get_combinations(tops, bottoms, options \\ []) do
    max_price = Keyword.get(options, :maximum_price, 100)
    for top <- tops,
        bottom <- bottoms,
        bottom[:base_color] != top[:base_color] and
            top[:price] + bottom[:price] <= max_price
    do
      {top, bottom}
    end
  end
end
