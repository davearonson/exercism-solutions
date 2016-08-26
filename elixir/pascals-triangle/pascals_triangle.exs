defmodule PascalsTriangle do
  @doc """
  Calculates the rows of a pascal triangle
  with the given height
  """
  @spec rows(integer) :: [[integer]]
  def rows(num) do
    do_rows(num, 1, [1], []) |> Enum.reverse
  end

  defp do_rows(max, max, prior, acc), do: [prior|acc]
  defp do_rows(max, cur, prior, acc) do
    do_rows(max, cur + 1, make_row(prior, [1]), [prior|acc])
  end
  
  defp make_row([_]         , acc), do: [1|acc]
  defp make_row([a|[b|more]], acc), do: make_row([b|more], [a+b|acc])

end
