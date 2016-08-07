defmodule Roman do
  @romans %{
   1000 =>  "M", 
    900 => "CM", 
    500 =>  "D", 
    400 => "CD", 
    100 =>  "C", 
     90 => "XC", 
     50 =>  "L", 
     40 => "XL", 
     10 =>  "X", 
      9 => "IX", 
      5 =>  "V", 
      4 => "IV", 
      1 =>  "I", 
  }

  @doc """
  Convert the number to a roman number.
  """
  @spec numerals(pos_integer) :: String.t
  def numerals(number) do
    # need to reverse 'cuz Elixir defaults to sorted, ascending
    do_numerals(number, Map.keys(@romans) |> Enum.reverse, "")
  end

  defp do_numerals(0, _, so_far), do: so_far

  defp do_numerals(number, [value | rest], so_far) do
    cond do
      value <= number ->
        do_numerals(number - value,
                    [value | rest],  # in case of 1-char repeats
                    "#{so_far}#{@romans[value]}")
      true ->
        do_numerals(number, rest, so_far)
    end
  end

end
