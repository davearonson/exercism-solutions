defmodule VariableLengthQuantity do
  @doc """
  Encode integers into a bitstring of VLQ encoded bytes
  """

  import Bitwise

  @spec encode(integers :: [integer]) :: binary
  def encode(integers) do
    Enum.flat_map(integers, &(do_encode(&1, 0, []))) |> Enum.join
  end

  defp do_encode(num, bit, acc) when num >= 128,
    do: do_encode(num >>> 7, 1, [<<bit::1, num::7>> | acc])

  defp do_encode(num, bit, acc), do: [<<bit::1, num::7>> | acc]

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
