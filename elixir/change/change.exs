defmodule Change do
  @doc """
    Determine the least number of coins to be given to the user such
    that the sum of the coins' value would equal the correct amount of change.
    It returns :error if it is not possible to compute the right amount of coins.
    Otherwise returns the tuple {:ok, map_of_coins}

    ## Examples

      iex> Change.generate(3, [5, 10, 15])
      :error

      iex> Change.generate(18, [1, 5, 10])
      {:ok, %{1 => 3, 5 => 1, 10 => 1}}

  """

  @spec generate(integer, list) :: {:ok, map} | :error
  def generate(amount, values) do
    make_change(amount, values |> Enum.sort |> Enum.reverse, %{})
  end

  # put zero case BEFORE no-values case 'cuz it's more likely, and
  # if we have both, we most likely came there directly (trying to
  # make zero change), so empty makes more sense than error.
  defp make_change(0     , _             , sofar), do: {:ok, sofar}
  defp make_change(_     , []            , _    ), do: :error
  defp make_change(amount, [largest|rest], sofar) when largest > amount do
    make_change(amount, rest,
                Map.put(sofar, largest, Map.get(sofar, largest, 0)))
  end
  defp make_change(amount, [largest|rest], sofar)  do
    make_change(amount - largest, [largest|rest],
                Map.put(sofar, largest, Map.get(sofar, largest, 0) + 1))
  end

end
