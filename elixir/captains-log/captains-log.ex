defmodule CaptainsLog do
  @planetary_classes ["D", "H", "J", "K", "L", "M", "N", "R", "T", "Y"]

  def random_planet_class() do
    Enum.random(@planetary_classes)
  end

  def random_ship_registry_number() do
    "NCC-#{Enum.random(1000..9999)}"
  end

  def random_stardate() do
    41000 + :rand.uniform() * 999.9
  end

  def format_stardate(stardate) do
    :io_lib.format("~7.1f", [stardate]) |> List.to_string
  end
end
