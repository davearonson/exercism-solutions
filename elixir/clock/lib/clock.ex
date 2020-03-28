defmodule Clock do
  defstruct hour: 0, minute: 0

  @doc """
  Returns a clock that can be represented as a string:

      iex> Clock.new(8, 9) |> to_string
      "08:09"
  """

  @hours_in_day 24
  @minutes_in_hour 60

  @spec new(integer, integer) :: Clock
  def new(hour, minute) do
    h =
      (hour + floor(minute / @minutes_in_hour))
      |> positive_remainder(@hours_in_day)
    m = positive_remainder(minute, @minutes_in_hour)
    %Clock{hour: h, minute: m}
  end

  defp positive_remainder(x, y) do
    r = rem(x, y)
    if r < 0, do: r + y, else: r
  end

  @doc """
  Adds two clock times:

      iex> Clock.new(10, 0) |> Clock.add(3) |> to_string
      "10:03"
  """
  @spec add(Clock, integer) :: Clock
  def add(%Clock{hour: hour, minute: minute}, add_minute) do
    new(hour, minute + add_minute)
  end

  defimpl String.Chars, for: Clock do
    @spec to_string(Clock) :: String
    def to_string(%Clock{hour: h, minute: m}) do
      "#{format_to_two_digits(h)}:#{format_to_two_digits(m)}"
    end

    @spec format_to_two_digits(integer) :: String
    defp format_to_two_digits(n) do
      n
      |> Integer.to_string()
      |> String.pad_leading(2, "0")
    end
  end
end
