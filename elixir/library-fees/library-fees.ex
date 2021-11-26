defmodule LibraryFees do
  @seconds_in_day 86_400

  def datetime_from_string(string) do
    NaiveDateTime.from_iso8601(string)
    |> elem(1)
  end

  def before_noon?(datetime) do
    datetime.hour < 12
  end

  def return_date(checkout_datetime) do
    days = if before_noon?(checkout_datetime), do: 28, else: 29
    checkout_datetime
    |> NaiveDateTime.add(days * @seconds_in_day)
    |> NaiveDateTime.to_date
  end

  def days_late(planned_return_date, actual_return_datetime) do
    due =
      planned_return_date
      |> NaiveDateTime.new(~T[00:00:00])
      |> elem(1)
    actual_return_datetime
    |> NaiveDateTime.diff(due)
    |> div(@seconds_in_day)
    |> max(0)
  end

  def monday?(datetime) do
    Date.new(datetime.year, datetime.month, datetime.day)
    |> elem(1)
    |> Date.day_of_week
    == 1
  end

  def calculate_late_fee(checkout, return, rate) do
    return_as_date = datetime_from_string(return)
    factor = if monday?(return_as_date), do: 0.5, else: 1.0
    (checkout
     |> datetime_from_string
     |> return_date
     |> days_late(return_as_date))
    * rate * factor
    |> trunc
  end
end
