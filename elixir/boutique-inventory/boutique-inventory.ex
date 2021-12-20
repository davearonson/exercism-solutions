defmodule BoutiqueInventory do
  def sort_by_price(inventory) do
    inventory |> Enum.sort_by(fn item -> item[:price] end)
  end

  def with_missing_price(inventory) do
    inventory |> Enum.filter(fn item -> ! item[:price] end)
  end

  def increase_quantity(item, count) do
    new_quantities = do_increase_quantity(item[:quantity_by_size], count)
    %{ item | quantity_by_size: new_quantities }
  end

  defp do_increase_quantity(sizes, count) do
    sizes
    |> Map.keys
    |> Enum.map(fn size -> {size, sizes[size] + count} end)
    |> Map.new
  end

  def total_quantity(item) do
    item[:quantity_by_size]
    |> Map.values
    |> Enum.reduce(0, &+/2)  # feedback says use reduce, else I'd just do sum!
  end
end
