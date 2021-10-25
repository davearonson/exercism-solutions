defmodule DNA do
  @encodings %{
    ?\s => 0b0000,
    ?A => 0b0001,
    ?C => 0b0010,
    ?G => 0b0100,
    ?T => 0b1000
  }

  @decodings Map.new(@encodings, fn {key, val} -> {val, key} end)

  def encode_nucleotide(code_point), do: @encodings[code_point]

  def decode_nucleotide(encoded_code), do: @decodings[encoded_code]

  def encode(dna, acc \\ <<>>)
  def encode([], acc), do: acc
  def encode([first|rest], acc) do
    encode(rest, <<acc::bitstring, <<@encodings[first]::4>>::bitstring>>)
  end

  def decode(bits, acc \\ [])
  def decode(<<>>, acc), do: Enum.reverse(acc)
  def decode(<<value::4, rest::bitstring>>, acc) do
    decode(rest, [@decodings[value]|acc])
  end
end
