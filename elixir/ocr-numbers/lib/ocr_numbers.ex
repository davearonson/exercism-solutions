defmodule OcrNumbers do
  @doc """
  Given a 3 x 4 grid of pipes, underscores, and spaces, determine which number is represented, or
  whether it is garbled.
  """

  @conversions %{
    " _ | ||_|   " => "0",
    "     |  |   " => "1",
    " _  _||_    " => "2",
    " _  _| _|   " => "3",
    "   |_|  |   " => "4",
    " _ |_  _|   " => "5",
    " _ |_ |_|   " => "6",
    " _   |  |   " => "7",
    " _ |_||_|   " => "8",
    " _ |_| _|   " => "9"
  }

  @spec convert([String.t()]) :: String.t()
  def convert(input) do
    if rem(length(input), 4) == 0 do
      result = input |> convert_four_rows([])
      {success, details} = result
      if success == :ok, do: {:ok, Enum.join(details, ",")},
      else: result
    else
      {:error, 'invalid line count'}
    end
  end

  defp convert_four_rows([], acc), do: {:ok, Enum.reverse(acc)}

  defp convert_four_rows(rows, acc) do
    result = convert_row(Enum.take(rows, 4))
    {success, details} = result
    if success == :ok do
      rows |> Enum.drop(4) |> convert_four_rows([details|acc])
    else
      result
    end
  end

  defp convert_row([first_digit|rest] = input) do
    len = String.length(first_digit)
    if rem(len, 3) == 0 and
       Enum.all?(rest, fn(s) -> String.length(s) == len end) do
      result =
        input
          |> Enum.map(&String.graphemes/1)
          |> convert_digits([])
      {:ok, result}
    else
      {:error, 'invalid column count'} 
    end
  end

  defp convert_digits([[],[],[],[]], acc) do
    acc |> Enum.reverse |> Enum.join
  end

  defp convert_digits(lines, acc) do
    string =
      lines
      |> Enum.map(fn (list) -> Enum.take(list, 3) end)
      |> Enum.join
    result = @conversions[string] || "?"
    rest = Enum.map(lines, fn (list) -> Enum.drop(list, 3) end)
    convert_digits(rest, [result|acc])
  end

end
