defmodule Transpose do
  @doc """
  Given an input text, output it transposed.

  Rows become columns and columns become rows. See https://en.wikipedia.org/wiki/Transpose.

  If the input has rows of different lengths, this is to be solved as follows:
    * Pad to the left with spaces.
    * Don't pad to the right.

  ## Examples
  iex> Transpose.transpose("ABC\nDE")
  "AD\nBE\nC"

  iex> Transpose.transpose("AB\nDEF")
  "AD\nBE\n F"
  """


  # don't use a char 'cuz it might be actually used
  @padsub 0


  @spec transpose(String.t()) :: String.t()
  def transpose(""), do: ""  # smartass!
  def transpose(input) do
    rows = String.split(input, "\n")
    max_len = 
      rows
      |> Enum.map(&String.length/1)
      |> Enum.max
    rows
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&(pad_to(&1, max_len)))
    |> do_transpose([])
    |> Enum.map(&(unpad(&1, false, [])))
    |> Enum.map(&Enum.join/1)
    |> Enum.join("\n")
  end


  def pad_to(arr, len) do
    cur_len = length(arr)
    if cur_len >= len do
      arr
    else
      arr ++ List.duplicate(@padsub, len - cur_len)
    end
  end


  def do_transpose([[]|_], acc), do: Enum.reverse(acc)
  def do_transpose(rows  , acc)  do
    { firsts, rests } = pop_rows(rows, [], [])
    do_transpose(rests, [firsts|acc])
  end


  def pop_rows([], firsts, rests) do
    { firsts, Enum.reverse(rests) }
  end

  def pop_rows([first_row|more_rows], firsts, rests) do
    { [first], rest } = Enum.split(first_row, 1)
    pop_rows(more_rows, [first|firsts], [rest|rests])
  end


  def unpad([@padsub|rest], false, acc), do: unpad(rest, false, acc)
  def unpad([@padsub|rest], true , acc), do: unpad(rest, true , [" "  |acc])
  def unpad([first  |rest], _    , acc), do: unpad(rest, true , [first|acc])
  def unpad([],             _    , acc), do: acc

end
