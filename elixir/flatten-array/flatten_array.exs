defmodule Flattener do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> Flattener.flatten([1, [2], 3, nil])
      [1,2,3]

      iex> Flattener.flatten([nil, nil])
      []

  """

  @spec flatten(list) :: list
  def flatten(list) do
    do_flatten(list, [])
  end

  defp do_flatten([], sofar), do: sofar

  defp do_flatten([head|tail], sofar) when is_list(head) do
    do_flatten(head, sofar) ++ do_flatten(tail, sofar)
  end

  defp do_flatten([nil |tail], sofar), do:         do_flatten(tail, sofar)
  defp do_flatten([head|tail], sofar), do: [head | do_flatten(tail, sofar)]

end
