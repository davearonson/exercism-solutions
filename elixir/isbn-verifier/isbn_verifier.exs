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
    new_isbn = remove_legit_dashes(isbn)
    if String.match?(new_isbn, ~r/^\d{9}(\d|X)$/) do
      try_checksum(new_isbn)
    else
      false
    end
  end

  defp checksum([]       , _ , acc), do: {:ok, acc }
  defp checksum([digit|rest], digit_number, acc) do
    # we've ensured, by regex call up top, that the X can only be last
    digit_value = if digit == "X", do: 10, else: String.to_integer(digit)
    new_acc = acc + digit_value * (11 - digit_number)
    checksum(rest, digit_number + 1, new_acc)
  end

  # remove dashes from ONLY where there are OK;
  # there are many styles but they all have in common that
  # the only legit place for a dash is between two digits
  defp remove_legit_dashes(string) do
    # Why dip, er, replace twice?  If you have one digit between
    # two dashes, replace will pick up from AFTER the replacement,
    # so it won't see the second dash as being preceded by a digit.  :-(
    # Could solve this with a more complex but efficient function,
    # but I don't wanna right now.  As is, this passes the ISBN rules
    # even for many non-English-speaking locations.
    string
      |> String.replace(~r/(\d)-(\d|X)/, "\\1\\2")
      |> String.replace(~r/(\d)-(\d|X)/, "\\1\\2")
  end

  defp try_checksum(isbn) do
    {status, result} =
      isbn
      |> String.graphemes
      |> checksum(1, 0)
    status == :ok && rem(result, 11) == 0
  end

end
