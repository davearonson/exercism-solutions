defmodule House do
  @doc """
  Return verses of the nursery rhyme 'This is the House that Jack Built'.
  """

  @poem_parts [
    "the horse and the hound and the horn that belonged to",
    "the farmer sowing his corn that kept",
    "the rooster that crowed in the morn that woke",
    "the priest all shaven and shorn that married",
    "the man all tattered and torn that kissed",
    "the maiden all forlorn that milked",
    "the cow with the crumpled horn that tossed",
    "the dog that worried",
    "the cat that killed",
    "the rat that ate",
    "the malt that lay in",
    "the house that Jack built."
  ] |> Enum.reverse |> List.to_tuple
  @part_count tuple_size(@poem_parts)

  @spec recite(start :: integer, stop :: integer) :: String.t()
  def recite(start, stop) do
    (start..stop)
    |> Enum.map(&make_verse/1)
    |> Enum.join
  end

  defp make_verse(n) do
    main_bit =
      ((n-1)..0)
      |> Enum.map(&(elem(@poem_parts, &1)))
      |> Enum.join(" ")
    "This is #{main_bit}\n"
  end
end
is is #{main_bit}\n"
  end
end
