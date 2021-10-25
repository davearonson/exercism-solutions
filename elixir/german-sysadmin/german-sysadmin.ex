defmodule Username do
  @conversions %{
    ?ä => 'ae',
    ?ö => 'oe',
    ?ü => 'ue',
    ?ß => 'ss'
  }

  @german_chars Map.keys(@conversions)

  def sanitize(list, acc \\ [])
  def sanitize([]          , acc), do: Enum.reverse(acc)
  def sanitize([first|rest], acc) do
    case first do
      x when x in ?a .. ?z ->
        sanitize(rest, [first|acc])
      ?_ ->
        sanitize(rest, [first|acc])
      x when x in @german_chars ->
        sanitize(rest, Enum.reverse(@conversions[first]) ++ acc)
      _ ->
        sanitize(rest, acc)
    end
  end
end
