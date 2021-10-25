defmodule BirdCount do
  def today([]  ), do: nil
  def today(list), do: hd(list)

  def increment_day_count([]  ), do: [1]
  def increment_day_count(list), do: [hd(list) + 1 | tl(list)]

  def has_day_without_birds?([]   ), do: false
  def has_day_without_birds?([0|_]), do: true
  def has_day_without_birds?(list ), do: has_day_without_birds?(tl(list))

  def total(list      , acc \\ 0)
  def total([]        , acc), do: acc
  def total([day|rest], acc), do: total(rest, acc + day)

  def busy_days(list, acc \\ 0)
  def busy_days([]        , acc), do: acc
  def busy_days([day|rest], acc) when day < 5, do: busy_days(rest, acc)
  def busy_days([_  |rest], acc), do: busy_days(rest, acc + 1)
end
