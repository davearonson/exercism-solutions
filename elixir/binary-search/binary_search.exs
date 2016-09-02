defmodule BinarySearch do
  @doc """
    Searches for a key in the list using the binary search algorithm.
    It returns :not_found if the key is not in the list.
    Otherwise returns the tuple {:ok, index}.

    ## Examples

      iex> BinarySearch.search([], 2)
      :not_found

      iex> BinarySearch.search([1, 3, 5], 2)
      :not_found

      iex> BinarySearch.search([1, 3, 5], 5)
      {:ok, 2}

  """

  @spec search(Enumerable.t, integer) :: {:ok, integer} | :not_found
  def search(list, key) do
    if Enum.sort(list) != list do
      raise ArgumentError, "expected list to be sorted"
    end
    tuple = List.to_tuple(list)
    do_search(tuple, key, 0, tuple_size(tuple) - 1)
  end

  defp do_search(_, _, min, max) when min > max, do: :not_found

  defp do_search(tuple, key, min, max) do
    idx = round((min + max) / 2)
    found = elem(tuple, idx)
    cond do
      found == key -> {:ok, idx}
      found < key  -> do_search(tuple, key, idx + 1, max)
      found > key  -> do_search(tuple, key, min,     idx - 1)
    end
  end

end
