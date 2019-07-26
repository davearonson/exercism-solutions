defmodule ISBNVerifier do
  @doc """
    Checks if a string is a valid ISBN-10 identifier

    ## Examples

      iex> ISBNVerifier.isbn?("3-598-21507-X")
      true

      iex> ISBNVerifier.isbn?("3-598-2K507-0")
      false

  """
  @spec isbn?(String.t()) :: boolean
  def isbn?(isbn) do
    {status, result} =
      isbn
      |> remove_legit_dashes
      |> String.graphemes
      |> checksum(1, 0)
    status == :ok && rem(result, 11) == 0
  end

  defp checksum([]       , 11, acc), do: {:ok, acc } # just right length, ended
  defp checksum([]       , _ , _  ), do: {:error, "too short" }
  defp checksum(_        , 11, _  ), do: {:error, "too long" }
  defp checksum(["X"]    , 10, acc), do: checksum(["10"], 10, acc)  # spcl case
  defp checksum([c|_]    , _ , _  ) when c < "0" or c > "9", do:
    {:error, "non-digit found, other than special exceptions"}
  defp checksum([digit|rest], digit_number, acc) do
    # in the case of a final X, digit will not really be a
    # single digit when we get here, but "10"; see "X" case above
    new_acc = acc + String.to_integer(digit) * (11 - digit_number)
    checksum(rest, digit_number + 1, new_acc)
  end

  # remove dashes from ONLY where there are OK;
  # there are many styles but they all have in common that
  # the only legit place for a dash is between two digits
  defp remove_legit_dashes(string) do
    # Why dip, er, replace twice?  If you have one digit between two
    # dashes, replace will pick up from AFTER the replacement,
    # so it won't see the second dash as being preceded by a digit.  :-(
    # Could solve this with a more complex but efficient function,
    # but I don't wanna right now.
    string
      |> String.replace(~r/(\d)-(\d|X)/, "\\1\\2")
      |> String.replace(~r/(\d)-(\d|X)/, "\\1\\2")
  end

end
