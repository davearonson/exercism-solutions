defmodule CustomSet do
  @opaque t :: %__MODULE__{map: map}  # requiring us to have a :map element?!

  defstruct [:map]

  @spec new(Enum.t()) :: t
  def new(enumerable) do
    if Enum.empty?(enumerable) do
      %CustomSet{}
    else
      %CustomSet{map:
        enumerable
        |> Enum.dedup
        |> Enum.map(fn e -> {e, True} end)
        |> Map.new
      }
    end
  end

  @spec empty?(t) :: boolean
  def empty?(custom_set) do
    custom_set |> get_map |> Enum.empty?
  end

  @spec contains?(t, any) :: boolean
  def contains?(custom_set, element) do
    Map.has_key?(get_map(custom_set), element)
  end

  @spec subset?(t, t) :: boolean
  def subset?(custom_set_1, custom_set_2) do
    elements(custom_set_1) -- elements(custom_set_2) == []
  end

  @spec disjoint?(t, t) :: boolean
  def disjoint?(custom_set_1, custom_set_2) do
    empty?(intersection(custom_set_1, custom_set_2))
  end

  @spec equal?(t, t) :: boolean
  def equal?(custom_set_1, custom_set_2) do
    elements(custom_set_1) == elements(custom_set_2)
  end

  @spec add(t, any) :: t
  def add(custom_set, element) do
    new_map = custom_set |> get_map |> Map.put(element, true)
    Map.put(custom_set, :map, new_map)
  end

  @spec intersection(t, t) :: t
  def intersection(custom_set_1, custom_set_2) do
    keys1 = elements(custom_set_1)
    keys2 = elements(custom_set_2)
    CustomSet.new(keys1 -- (keys1 -- keys2))
  end

  @spec difference(t, t) :: t
  def difference(custom_set_1, custom_set_2) do
    cond do
      empty?(custom_set_1) -> CustomSet.new([])
      empty?(custom_set_2) -> custom_set_1
      true -> CustomSet.new(elements(custom_set_1) -- elements(custom_set_2))
    end
  end

  @spec union(t, t) :: t
  def union(custom_set_1, custom_set_2) do
      CustomSet.new(elements(custom_set_1) ++ elements(custom_set_2))
  end

  defp get_map(custom_set), do: custom_set.map || %{}

  defp elements(custom_set), do: custom_set |> get_map |> Map.keys
end
