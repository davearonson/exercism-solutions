defmodule Scrabble do

  # COULD map value to array of letters, or string, but that would
  # make code more complex, and updates more cumbersome.
  @letter_values %{
    "A" =>   1,
    "B" =>   3,
    "C" =>   3,
    "D" =>   2,
    "E" =>   1,
    "F" =>   4,
    "G" =>   2,
    "H" =>   4,
    "I" =>   1,
    "J" =>   8,
    "K" =>   5,
    "L" =>   1,
    "M" =>   3,
    "N" =>   1,
    "O" =>   1,
    "P" =>   3,
    "Q" =>  10,
    "R" =>   1,
    "S" =>   1,
    "T" =>   1,
    "U" =>   1,
    "V" =>   4,
    "W" =>   4,
    "X" =>   8,
    "Y" =>   4,
    "Z" =>  10
  }

  @doc """
  Calculate the scrabble score for the word.
  """
  @spec score(String.t) :: non_neg_integer
  def score(word) do
    word
    |> String.upcase
    |> String.graphemes
    |> Enum.map(&letter_value/1)
    |> Enum.sum
  end

  # COULD have inlined this, but extracting it
  # makes score/1 easier to grok
  # by staying closer to same level of abstraction
  defp letter_value(letter) do
    Map.get(@letter_values, letter, 0)
  end

end
