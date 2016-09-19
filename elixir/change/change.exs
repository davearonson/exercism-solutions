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
  def generate(amount, _     ) when amount <= 0, do: :error
  def generate(_     , []    )                 , do: :error
  def generate(amount, values) do
    do_generate(amount,
                values |> Enum.sort |> Enum.reverse,
                # thanks to exercism.io user MatthewMDavis
                # for the idea of prepopulating the map with zeroes;
                # that vastly simplified the do_generate code!
                Map.new(values, &({&1, 0})))
    || :error
  end

  defp do_generate(0, _ , sofar), do: {:ok, sofar}
  defp do_generate(_, [], _    ), do: false

  defp do_generate(amount, [largest|rest], sofar) when largest > amount do
    do_generate(amount, rest, sofar)
  end

  defp do_generate(amount, [largest|rest], sofar)  do
    # TODO MAYBE: see if we can preserve tail-call optimization somehow?
    do_generate(amount - largest,
                [largest|rest],
                %{sofar | largest => sofar[largest] + 1})
    # depending what exact coins we have, applying the largest one
    # may give us something we can't do with the rest of them!
    || do_generate(amount, rest, sofar)
  end

end
