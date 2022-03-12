defmodule ResistorColorTrio do
  @color_values %{
    black:  0,
    brown:  1,
    red:    2,
    orange: 3,
    yellow: 4,
    green:  5,
    blue:   6,
    violet: 7,
    grey:   8,
    white:  9
  }
  
  @doc """
  Calculate the resistance value in ohm or kiloohm from resistor colors
  """
  @spec label(colors :: [atom]) :: {number, :ohms | :kiloohms}
  def label(colors) do
    [tens, ones, zeroes] = colors |> Enum.map(&(@color_values[&1]))
    val = (tens * 10 + ones) * 10**zeroes
    if val >= 1000 do  # yes we're ignoring megaohms etc.
      {val / 1000, :kiloohms}
    else
      {val, :ohms}
    end
  end
end
