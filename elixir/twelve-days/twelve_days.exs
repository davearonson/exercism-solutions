defmodule TwelveDays do

  @doc """
  Given a `number`, return the song's verse for that specific day, including
  all gifts for previous days in the same line.
  """
  @spec verse(number :: integer) :: String.t()
  def verse(number) do
    "On the #{ordinal(number)} day of Christmas my true love gave to me, #{gift_list(number)}."
  end

  @doc """
  Given a `starting_verse` and an `ending_verse`, return the verses for each
  included day, one per line.
  """
  @spec verses(starting_verse :: integer, ending_verse :: integer) :: String.t()
  def verses(starting_verse, ending_verse) do
    (starting_verse..ending_verse)
    |> Enum.map(&verse/1)
    |> Enum.join("\n")
  end

  @doc """
  Sing all 12 verses, in order, one verse per line.
  """
  @spec sing():: String.t()
  def sing do
    verses(1,12)
  end

  ### PRIVATE STUFF

  @gifts {
    "nothing, just here to make the indexing start at 1, not 0",
    "a Partridge in a Pear Tree",
    "two Turtle Doves",
    "three French Hens",
    "four Calling Birds",
    "five Gold Rings",
    "six Geese-a-Laying",
    "seven Swans-a-Swimming",
    "eight Maids-a-Milking",
    "nine Ladies Dancing",
    "ten Lords-a-Leaping",
    "eleven Pipers Piping",
    "twelve Drummers Drumming"
  }

  @ordinals {
    "nothing, just here to make the indexing start at 1, not 0",
    "first",
    "second",
    "third",
    "fourth",
    "fifth",
    "sixth",
    "seventh",
    "eighth",
    "ninth",
    "tenth",
    "eleventh",
    "twelfth"
  }

  defp ordinal(number) do
    elem(@ordinals, number)
  end

  defp gift_list(1), do: gift(1)
  defp gift_list(number) do
    # Elixir does not have an Enum.join/3 taking something to put
    # only before the last one :-(
    "#{number..2 |> Enum.map(&gift/1) |> Enum.join(", ")}, and #{gift(1)}"
  end

  defp gift(number), do: elem(@gifts, number)

end

