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
  def generate(count), do: do_generate(3, count, [1,2])

  # yes I know this solution doesn't use streams,
  # but I want to show that they're not needed for this!
  defp do_generate(cur, max, acc) when cur > max, do:
    Enum.reverse(acc)
  defp do_generate(cur, max, acc = [prev|[prev2|_rest]]), do:
    do_generate(cur + 1, max, [prev+prev2|acc])
end
