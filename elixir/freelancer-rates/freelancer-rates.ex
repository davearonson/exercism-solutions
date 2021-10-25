defmodule FreelancerRates do
  def daily_rate(hourly_rate) do
    hourly_rate * 8.0
  end

  def apply_discount(before_discount, discount) do
    before_discount * (1.0 - discount * 0.01)
  end

  def monthly_rate(hourly_rate, discount) do
    discounted_daily_rate(hourly_rate, discount) * 22
    |> Float.ceil
    |> trunc
  end

  def days_in_budget(budget, hourly_rate, discount) do
    (budget / discounted_daily_rate(hourly_rate, discount))
    |> Float.floor(1)
  end

  defp discounted_daily_rate(hourly_rate, discount) do
    hourly_rate |>
    apply_discount(discount) |>
    daily_rate
  end
end
