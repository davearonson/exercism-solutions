defmodule KitchenCalculator do
  def get_volume({_, num}) do
    num
  end

  @to_ml_conversions %{
    milliliter:   1,
    cup:        240,
    fluid_ounce: 30,
    teaspoon:     5,
    tablespoon:  15
  }

  def to_milliliter({unit, num}) do
    {:milliliter, num * @to_ml_conversions[unit]}
  end

  def from_milliliter(volume_pair, unit) do
    {unit, get_volume(volume_pair) / @to_ml_conversions[unit]}
  end

  def convert(volume_pair, unit) do
    volume_pair
    |> to_milliliter
    |> from_milliliter(unit)
  end
end
