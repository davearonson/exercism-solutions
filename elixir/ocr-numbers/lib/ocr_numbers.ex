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
    with {:ok, _}         <- check_matrix_height(input),
         rows             <- Enum.chunk_every(input, 4),
         {:ok, converted} <- convert_rows(rows, [])
    do
      {:ok, Enum.join(converted, ",")}
    else
      err -> err
    end
  end

  defp check_matrix_height(input) do
    case rem(length(input), 4) do
      0 -> {:ok, nil}
      _ -> {:error, 'invalid line count'}
    end
  end

  defp convert_rows([]          , acc), do: {:ok, Enum.reverse(acc)}
  defp convert_rows([first|rest], acc)  do
    with {:ok, result} <- convert_row(first) do
      convert_rows(rest, [result|acc])
    else
      err -> err
    end
  end

  defp convert_row(input) do
    if check_matrix_width(input) do
      result =
        input
        |> Enum.map(&String.graphemes/1)
        |> ocr_digits([])
        |> Enum.join
      {:ok, result}
    else
      {:error, 'invalid column count'} 
    end
  end

  defp check_matrix_width([top_line|rest]) do
    len = String.length(top_line)
    rem(len, 3) == 0 and Enum.all?(rest, &(String.length(&1) == len))
  end

  defp ocr_digits([[],[],[],[]], acc), do: Enum.reverse(acc)
  defp ocr_digits(input        , acc)  do
    this_digit = Enum.map(input, &(Enum.take(&1, 3)))
    rest       = Enum.map(input, &(Enum.drop(&1, 3)))
    converted  = @conversions[Enum.join(this_digit)] || "?"
    ocr_digits(rest, [converted|acc])
  end

end
