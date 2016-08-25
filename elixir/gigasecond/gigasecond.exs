defmodule Gigasecond do
  @doc """
  Calculate a date one billion seconds after an input date.
  """

  @one_billion 1_000_000_000

  @spec from({{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}) :: :calendar.datetime
  # def from({{year, month, day}, {hours, minutes, seconds}}) do
    def from(time) do
      ((time|> :calendar.datetime_to_gregorian_seconds) + @one_billion)
      |> :calendar.gregorian_seconds_to_datetime
    end
end
