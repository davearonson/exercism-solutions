defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
      :monday | :tuesday | :wednesday
    | :thursday | :friday | :saturday | :sunday

  @weekdays [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday]

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: :calendar.date
  def meetup(year, month, weekday, schedule) do
    do_meetup(year, month, first_wanted_weekday(year, month, weekday), schedule)
  end

  defp do_meetup(year, month, first, schedule) do
    { year, month, case schedule do
                     :first  -> first
                     :second -> first + 7
                     :third  -> first + 14
                     :fourth -> first + 21
                     :last   -> last_weekday(year, month, first)
                     :teenth -> teenth_weekday(first)
                   end
    }
  end

  defp first_wanted_weekday(year, month, weekday) do
    # there OUGHT to be some way to convert weekdays to integers automagically,
    # without needing a handcrafted array and doing find_index....
    rem(Enum.find_index(@weekdays, &(&1 == weekday)) + 8 - month_start_day(year, month), 7) + 1
  end

  def month_start_day(year, month) do
    :calendar.day_of_the_week year, month, 1
  end

  defp last_weekday(year, month, first) do
    temp = first + 28
    if temp > :calendar.last_day_of_the_month(year, month) do
      temp - 7
    else
      temp
    end
  end

  defp teenth_weekday(first) when first < 6, do: first + 14
  defp teenth_weekday(first), do: first + 7

end
