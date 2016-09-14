defmodule Series do

  @doc """
  Finds the largest product of a given number of consecutive numbers in a given string of numbers.
  """
  @spec largest_product(String.t, non_neg_integer) :: non_neg_integer

  def largest_product(_            ,    0), do: 1
  def largest_product(number_string, size) do
    if size < 0 || size > String.length(number_string), do: raise ArgumentError
    do_largest_product(number_string
                       |> String.graphemes
                       |> Enum.map(&String.to_integer/1),
                       size,
                       0)
  end

  # take next N numbers and multiply, rather than divide by the
  # oldest and multiply by the next, because there may be zeroes.
  defp do_largest_product(list, size, highest) do
    cur_numbers = list |> Enum.take(size)
    if length(cur_numbers) == size do
      do_largest_product(tl(list),
                         size,
                         Enum.max([highest,
                                   cur_numbers |> Enum.reduce(&*/2)]))
    else
      highest
    end
  end

end
