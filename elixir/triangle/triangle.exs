defmodule Triangle do
  @type kind :: :equilateral | :isosceles | :scalene

  @doc """
  Return the kind of triangle of a triangle with 'a', 'b' and 'c' as lengths.
  """
  @spec kind(number, number, number) :: { :ok, kind } | { :error, String.t }
  def kind(a, b, c) do
    [x, y, z] = Enum.sort([a, b, c])
    do_kind(x, y, z)
  end

  defp do_kind(a, _, _) when a <= 0 do  # no need to check the others
    { :error, "all side lengths must be positive" }
  end

  defp do_kind(a, b, c) when a+b <= c do
    { :error, "side lengths violate triangle inequality" }
  end

  defp do_kind(a, a, a), do: { :ok, :equilateral }

  defp do_kind( a, a, _b), do: { :ok, :isosceles }
  defp do_kind(_a, b,  b), do: { :ok, :isosceles }
  # can't be on the ends 'cuz they're sorted

  defp do_kind(_a, _b, _c), do: { :ok, :scalene }
end
