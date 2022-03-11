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
    "the house that Jack built.\n"
  ] |> Enum.reverse |> List.to_tuple

  # a bit more complex than just mapping over the ranges,
  # but definitely more performant, roughly order(n), whereas
  # mapping inside mapping would be roughly order(n).
  # doesn't matter at this scale, but if one were to use
  # the algorithms for something similar at much larger scale....
  @spec recite(start :: integer, stop :: integer) :: String.t()
  def recite(start, stop), do:
    do_recite(start, stop, 1, "", [])

  defp do_recite(start, stop, n, lines_acc, verses_acc)
       when n < start do
    do_recite(start, stop, n+1,
              make_new_lines_acc(n, lines_acc), verses_acc)
  end

  defp do_recite(_, stop, n, _, verses_acc)
       when n > stop do
    verses_acc
    |> Enum.reverse
    |> Enum.join
  end

  defp do_recite(start, stop, n, lines_acc, verses_acc) do
    new_lines_acc = make_new_lines_acc(n, lines_acc)
    do_recite(start, stop, n+1, new_lines_acc,
              ["This is #{new_lines_acc}"|verses_acc])
  end

  defp make_new_lines_acc(n, ""), do: poem_part(n)
  defp make_new_lines_acc(n, sofar), do: "#{poem_part(n)} #{sofar}"

  defp poem_part(n), do: elem(@poem_parts, n-1)
end
