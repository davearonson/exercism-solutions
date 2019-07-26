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
    {status, result} = isbn |> String.graphemes |> checksum(1, 0)
    if status == :ok do
      rem(result, 11) == 0
    else
      # don't really print it, it clutters up test results,
      # but there should be some way to tell the caller why not.
      # IMHO the return of this function ought to be one of:
      # {:ok, proper_total}
      # {:error, invalid_total} or maybe {:error, message_about_invalid_total} 
      # {:error, error_message}
      # IO.puts result
      false
    end
  end

  defp checksum([]       , 11, acc), do: {:ok, acc } # just right length, ended
  defp checksum([]       , _ , _  ), do: {:error, "too short" }
  defp checksum(_        , 11, _  ), do: {:error, "too long" }
  defp checksum(["-"|cdr],  2, acc), do: checksum(cdr,  2, acc)  # dashes OK,
  defp checksum(["-"|cdr],  5, acc), do: checksum(cdr,  5, acc)  # but ONLY AT
  defp checksum(["-"|cdr], 10, acc), do: checksum(cdr, 10, acc)  # THESE SPOTS!
  defp checksum(["X"]    , 10, acc), do: checksum(["10"], 10, acc)  # spcl case
  defp checksum([c|_]    , _ , _  ) when c < "0" or c > "9", do:
    {:error, "non-digit found, other than special exceptions"}
  defp checksum([digit|rest], digit_number, acc) do
    new_acc = acc + String.to_integer(digit) * (11 - digit_number)
    checksum(rest, digit_number + 1, new_acc)
  end

end
