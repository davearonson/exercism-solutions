defmodule Say do
  @doc """
  Translate a positive integer into English.
  """

  @ones_names %{
     # don't need zero
     1 => "one",
     2 => "two",
     3 => "three",
     4 => "four",
     5 => "five",
     6 => "six",
     7 => "seven",
     8 => "eight",
     9 => "nine",
    10 => "ten",
    11 => "eleven",
    12 => "twelve",
    13 => "thirteen",
    14 => "fourteen",
    15 => "fifteen",
    16 => "sixteen",
    17 => "seventeen",
    18 => "eighteen",
    19 => "nineteen"
  }

  @tens_names %{
    # don't need 0 or 1, the way this is used (only for 20-99)
    2 => "twenty",
    3 => "thirty",
    4 => "forty",
    5 => "fifty",
    6 => "sixty",
    7 => "seventy",
    8 => "eighty",
    9 => "ninety"
  }


  @spec in_english(integer) :: {atom, String.t()}

  def in_english(number) when number < 0, do:
    {:error, "number is out of range"}

  def in_english(number) when number >= 1_000_000_000_000, do:
    {:error, "number is out of range"}

  def in_english(0), do: {:ok, "zero"}

  def in_english(number) do
    result =
      digit_groups_in_increasing_order(number)
      |> Enum.map(&englishize_group/1)
      |> label_groups
      |> Enum.reverse
      |> join_non_nils(" ")
    {:ok, result}
  end


  defp digit_groups_in_increasing_order(n, acc \\ [])
  defp digit_groups_in_increasing_order(0, acc), do: Enum.reverse(acc)
  defp digit_groups_in_increasing_order(number, acc) do
    digit_groups_in_increasing_order(div(number, 1000),
                                    [rem(number, 1000) | acc])
  end


  defp englishize_group(number) when number >= 100 do
    hundreds = div(number, 100)
    rest     = rem(number, 100)
    parts    = [@ones_names[hundreds], "hundred", englishize_group(rest)]
    join_non_nils(parts, " ")
  end

  defp englishize_group(number) when number >= 20 do
    tens = div(number, 10)
    rest = rem(number, 10)
    parts = [@tens_names[tens], englishize_group(rest)]
    join_non_nils(parts, "-")
  end

  defp englishize_group(number), do: @ones_names[number]


  defp join_non_nils(pieces, sep) do
    pieces |> Enum.reject(&is_nil/1) |> Enum.join(sep)
  end


  def label_groups(groups) do
    groups
    |> Enum.zip([nil, "thousand", "million", "billion"])
    |> Enum.map(&label_one_group/1)
  end


  defp label_one_group({nil  , _   }), do: nil
  defp label_one_group({group, nil }), do: group
  defp label_one_group({group, name}), do: "#{group} #{name}"

end
