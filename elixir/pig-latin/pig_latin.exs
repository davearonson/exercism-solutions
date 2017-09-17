defmodule PigLatin do
  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.

  Words beginning with consonants should have the consonant moved to the end of
  the word, followed by "ay".

  Words beginning with vowels (aeiou) should have "ay" added to the end of the
  word.

  Some groups of letters are treated like consonants, including "ch", "qu",
  "squ", "th", "thr", and "sch".

  Some groups are treated like vowels, including "yt" and "xr".
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    phrase
    |> String.split
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&do_translate(&1, []))
    |> Enum.join(" ")
  end

  defp do_translate(word=[vowel|rest], acc)
      when vowel in ~w(a e i o u) do
    "#{word}#{acc|>Enum.reverse}ay"
  end

  defp do_translate(word=[special,consonant|rest], [])
      when special in ~w(x y)
           and not consonant in ~w(a e i o u) do
    "#{word}ay"
  end

  defp do_translate(["q", "u"|rest], acc) do
    do_translate(rest, ["u", "q" | acc])
  end

  defp do_translate([first|rest], acc) do
    do_translate(rest, [first|acc])
  end
end
