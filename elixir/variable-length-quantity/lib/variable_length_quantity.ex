defmodule VariableLengthQuantity do
  @doc """
  Encode integers into a bitstring of VLQ encoded bytes
  """
  @spec encode(integers :: [integer]) :: binary
  def encode(integers) do
    integers
    |> Enum.map(&do_encode/1)
    |> Enum.join
  end

  defp do_encode(0), do: <<0>>
  defp do_encode(integer) do
    integer
    |> get_bits
    |> pad_to_mult_of(7, 0)
    |> Enum.chunk_every(7)  # WHY is there no :backward option, or -step?
    |> Enum.drop_while(&all_zeroes/1)
    |> make_bytes
    |> Enum.into(<<>>, fn x -> <<x>> end)
  end

  defp get_bits(n) do
    n
    |> Integer.digits(2)
    |> pad_to_mult_of(8, 0)
  end

  defp pad_to_mult_of(list, factor,  what, len \\ false) do
    new_len = if len, do: len, else: length(list)
    if rem(new_len, factor) == 0 do
      list
    else
      pad_to_mult_of([what | list], factor,  what, new_len + 1)
    end
  end

  defp all_zeroes(bits), do: Enum.all?(bits, fn bit -> bit == 0 end)

  defp make_bytes(bytes,         acc \\ [])
  defp make_bytes([],            acc), do: acc
  defp make_bytes([byte],        acc), do: [last_byte(byte) | acc]
  defp make_bytes([byte | rest], acc),
    do: [non_last_byte(byte) | make_bytes(rest, acc)]

  defp last_byte(byte) do
    byte
    |> pad_to_mult_of(7, 0)
    |> List.insert_at(0, 0)
    |> to_byte
  end

  defp non_last_byte(byte) do
    byte
    |> List.insert_at(0, 1)
    |> to_byte
  end

  defp to_byte(bits) do
    bits
    |> Enum.join
    |> String.to_integer(2)
  end

  @doc """
  Decode a bitstring of VLQ encoded bytes into a series of integers
  """
  @spec decode(bytes :: binary) :: {:ok, [integer]} | {:error, String.t()}
  def decode(bytes) do
    bytes
    |> :binary.bin_to_list
    |> do_decode([], 0)
  end

  defp do_decode([byte|rest], big_acc, lil_acc) when byte >= 128,
    do: do_decode(rest, big_acc, lil_acc * 128 + byte - 128)
  defp do_decode([byte|rest], big_acc, lil_acc),
    do: do_decode(rest, [lil_acc * 128 + byte | big_acc], 0)
  defp do_decode([], []     , _lil_acc), do: {:error, "incomplete sequence"}
  defp do_decode([], big_acc, _lil_acc), do: {:ok, Enum.reverse(big_acc) }
end
