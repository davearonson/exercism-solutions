defmodule LucasNumbers do
  @moduledoc """
  Lucas numbers are an infinite sequence of numbers which build progressively
  which hold a strong correlation to the golden ratio (φ or ϕ)

  E.g.: 2, 1, 3, 4, 7, 11, 18, 29, ...
  """
  def generate(x) when not is_integer(x) or x < 1, do:
    raise ArgumentError, message: "count must be specified as an integer >= 1"
  def generate(1), do: [2]
  def generate(2), do: [2,1]
  def generate(count) do
    # could do it all from scratch, but i wanted to minimize
    # hardcoding of values and calls to gen_next_pair.
    # no biggie in this case, but if g_n_p were expensive, yes.
    base = generate(2)
    more =
      Stream.unfold(List.to_tuple(base), &gen_next_pair/1)
      |> Enum.take(count - 2)
    base ++ more
  end

  defp gen_next_pair({prev, last}) do
    next = last + prev
    {next, {last, next}}
  end
end
