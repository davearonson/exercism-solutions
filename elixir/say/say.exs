defmodule Say do
  @doc """
  Translate a positive integer into English.
  """

  @group_names {"thousand", "million", "billion"}

  @ones_names %{
    "0" => "",
    "1" => "one",
    "2" => "two",
    "3" => "three",
    "4" => "four",
    "5" => "five",
    "6" => "six",
    "7" => "seven",
    "8" => "eight",
    "9" => "nine"
  }

  @teens_names %{
    "0" => "ten",
    "1" => "eleven",
    "2" => "twelve",
    "3" => "thirteen",
    "4" => "fourteen",
    "5" => "fifteen",
    "6" => "sixteen",
    "7" => "seventeen",
    "8" => "eighteen",
    "9" => "nineteen"
  }

  @tens_names %{
    # 0 and 1 are taken care of by special cases
    "2" => "twenty",
    "3" => "thirty",
    "4" => "forty",
    "5" => "fifty",
    "6" => "sixty",
    "7" => "seventy",
    "8" => "eighty",
    "9" => "ninety"
  }


  @spec in_english(integer) :: {atom, String.t()}

  def in_english(number) when number < 0, do:
    {:error, "number is out of range" }

  def in_english(number) when number >= 1_000_000_000_000, do:
    {:error, "number is out of range"}

  def in_english(0), do: {:ok, "zero"}

  def in_english(number) do
    result =
      digit_groups_in_increasing_order(number)
      |> Enum.map(&englishize_group/1)
      |> label_groups(0, [])
      |> Enum.join(" ")
    {:ok, result}
  end


  defp englishize_group(["0", tens, ones]), do: englishize_group([tens, ones])

  defp englishize_group([hundreds, tens, ones]) do
    [@ones_names[hundreds], "hundred", englishize_group([tens, ones])]
    |> join_non_nils(" ")
  end

  defp englishize_group(["0", ones]), do: englishize_group([ones])

  defp englishize_group(["1", ones]), do: @teens_names[ones]

  defp englishize_group([tens, ones]) do
    [@tens_names[tens], englishize_group([ones])] |> join_non_nils("-")
  end

  defp englishize_group(["0"]), do: nil

  defp englishize_group([digit]), do: @ones_names[digit]


  defp join_non_nils(pieces, sep) do
    pieces |> Enum.reject(&is_nil/1) |> Enum.join(sep)
  end


  defp label_groups([], _, acc), do: acc

  defp label_groups([nil | more_groups], group_num, acc) do
    label_groups(more_groups, group_num + 1, acc)
  end

  defp label_groups([group | more_groups], 0, acc) do
    label_groups(more_groups, 1, [group | acc])
  end

  defp label_groups([group | more_groups], group_num, acc) do
    result = "#{group} #{elem(@group_names, group_num - 1)}"
    label_groups(more_groups, group_num + 1, [result | acc])
  end


  defp digit_groups_in_increasing_order(number) do
    number
    |> Integer.to_string
    |> String.graphemes
    |> Enum.reverse
    |> Enum.chunk_every(3)
    |> Enum.map(&Enum.reverse/1)
  end

end
