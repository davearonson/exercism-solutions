defmodule Year do
  @doc """
  Returns whether 'year' is a leap year.

  A leap year occurs:

  on every year that is evenly divisible by 4
    except every year that is evenly divisible by 100
      except every year that is evenly divisible by 400.
  """
  @spec leap_year?(non_neg_integer) :: boolean
  def leap_year?(year) do
    # need to reverse else it iterates in ASCENDING order :-(
    check_leap(year, Enum.reverse(%{ 400 => true, 100 => false, 4 => true }))
  end

  defp check_leap(_, []), do: false

  defp check_leap(year, [mult | rest]) do
    cond do
      rem(year, elem(mult, 0)) == 0 -> elem(mult, 1)
      true -> check_leap(year, rest)
    end
  end

end
