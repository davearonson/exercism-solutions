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
  @pad -1

  @spec transpose(String.t()) :: String.t()
  def transpose(""   ), do: ""  # smartass!
  def transpose(input)  do
    rows = String.split(input, "\n")
    max_len = 
      rows
      |> Enum.map(&String.length/1)
      |> Enum.max
    rows
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&(pad_to(&1, max_len)))
    |> Enum.zip
    |> Enum.map(&fixup/1)
    |> Enum.map(&Enum.join/1)
    |> Enum.join("\n")
  end

  defp pad_to(arr, len) do
    cur_len = length(arr)
    if cur_len >= len do
      arr
    else
      # yes this can be inefficient with long input strings,
      # but we're not worried about that in this use-case
      arr ++ List.duplicate(@pad, len - cur_len)
    end
  end

  defp fixup(tup) do
    tup
    |> Tuple.to_list
    |> Enum.reverse
    |> do_unpad(false, [])
    # do not reverse here; between fixup and do_unpad we need an odd number
    # of explicit reversals (to counter the implicit one from do_unpad),
    # the one above is needed, and the other solution, of reversing both here
    # and at the end of do_unpad, would be redundant.
  end

  # middle arg means, have we seen something yet that's not a pad substitute?
  defp do_unpad([@pad|rest], false, acc), do: do_unpad(rest, false, acc)
  defp do_unpad([@pad|rest], true , acc), do: do_unpad(rest, true,  [" " |acc])
  defp do_unpad([last|rest], _    , acc), do: do_unpad(rest, true,  [last|acc])
  defp do_unpad([]         , _    , acc), do: acc  # see comment in fixup

end
