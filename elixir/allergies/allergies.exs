defmodule Allergies do

  use Bitwise

  @allergies \
    ~w(eggs peanuts shellfish strawberries tomatoes chocolate pollen cats)

  @doc """
  List the allergies for which the corresponding flag bit is true.
  """
  @spec list(non_neg_integer) :: [String.t]
  def list(flags) do
    do_list(flags, @allergies, [])
  end

  defp do_list(flags, [allergen|more], acc) when rem(flags, 2) == 1 do
    do_list(flags >>> 1, more, [allergen|acc])
  end
  defp do_list(flags, [_|more], acc), do: do_list(flags >>> 1, more, acc)
  defp do_list(_    , []      , acc), do: acc


  @doc """
  Returns whether the corresponding flag bit in 'flags' is set for the item.
  """
  @spec allergic_to?(non_neg_integer, String.t) :: boolean
  def allergic_to?(flags, item) do
    # pick one of the two below implementations;
    # the first is more elixirish but the second
    # seems likely to be more efficient.
    # do_allergic_to?(flags, item, @allergies)
    do_allergic_to?(flags,
                    Enum.find_index(@allergies, fn(x) -> x == item end))
  end

  defp do_allergic_to?(flags, item, [item|_]), do: rem(flags, 2) == 1
  defp do_allergic_to?(flags, item, [_|more])  do
    do_allergic_to?(flags, item, more)
  end
  defp do_allergic_to?(_    , _   , []      ), do: false

  # this case was not in the tests but we should cover it anyway
  defp do_allergic_to?(_    , nil), do: false
  defp do_allergic_to?(flags, idx), do: (flags &&& (1 <<< idx)) != 0

end
