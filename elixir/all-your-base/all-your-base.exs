defmodule AllYourBase do
  @doc """
  Given a number in base a, represented as a sequence of digits, converts it to base b,
  or returns nil if either of the bases are less than 2
  """

  @spec convert(list, integer, integer) :: list

  def convert([],      _base_a, _base_b), do: nil
  def convert(_digits,  base_a,  base_b) when base_a < 2 or base_b < 2, do: nil
  def convert( digits,  base_a,  base_b) do
    with {:ok, value}        <- read_digits_in_base(digits, base_a, 0),
         {:ok, new_digits}   <- write_digits_in_base(value, base_b, []),
         {:ok, final_digits} <- fix_digit_list(new_digits)
    do
      final_digits
    else
      err -> err
    end
  end

  defp read_digits_in_base([head|_tail], _base, _acc) when head < 0, do: nil
  defp read_digits_in_base([head|_tail],  base, _acc) when head >= base, do: nil
  defp read_digits_in_base([]          , _base,  acc), do: {:ok, acc}
  defp read_digits_in_base([head|tail],   base,  acc)  do
    read_digits_in_base(tail, base, acc * base + head)
  end

  defp write_digits_in_base(    0, _base, acc), do: {:ok, acc}
  defp write_digits_in_base(value,  base, acc)  do
    write_digits_in_base(div(value, base), base, [rem(value, base)|acc])
  end

  defp fix_digit_list([]    ), do: {:ok, [0]}
  defp fix_digit_list(digits), do: {:ok, digits}

end
