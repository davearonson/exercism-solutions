defmodule BeerSong do
  @where "on the wall"
  @doc """
  Get a single verse of the beer song
  """
  @spec verse(integer) :: String.t
  def verse(number) do
    # Could have put functions in terms of verse number,
    # but by number of bottles is MUCH clearer!
    count = rem(number - 2, 100) + 1
    """
#{how_many_what(count, :capitalized)} #{@where}, #{how_many_what(count)}.
#{action(count)}, #{how_many_what(remainder(count))} #{@where}.
    """
  end

  defp how_many_what(count, treatment \\ :none) do
    "#{how_many(count, treatment)} bottle#{pluralizer(count)} of beer"
  end

  defp how_many(0, :capitalized), do: "No more"
  defp how_many(0, _), do: "no more"
  defp how_many(count, _), do: count

  defp pluralizer(1), do: ""
  defp pluralizer(_), do: "s"

  defp action(0), do: "Go to the store and buy some more"
  defp action(count) do
    "Take #{to_pass(count)} down and pass it around"
  end

  defp to_pass(1), do: "it"
  defp to_pass(_), do: "one"

  # could also do modulo math, but this reveals intent better imho
  defp remainder(0), do: 99
  defp remainder(count), do: count - 1

  @doc """
  Get the entire beer song for a given range of numbers of bottles.
  """
  @spec lyrics(Range.t) :: String.t
  def lyrics(range \\ 100..1) do
    Enum.map(range, &(verse &1)) |> Enum.join("\n")
  end
end
