defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t, pos_integer) :: String.t
  def encode(str, rails) do
    count_up = 1..rails
    cycle = if rails > 2 do
              Enum.concat(count_up, (rails - 1)..2)
            else
              count_up
            end
    cycle
    |> Stream.cycle
    |> Enum.zip(String.graphemes(str))
    |> encode_rails(%{})
    |> Enum.join
  end

  defp encode_rails([{rail,char}|more], acc) do
    encode_rails(more, Map.put(acc, rail, [char|Map.get(acc, rail, [])]))
  end

  defp encode_rails([], acc) do
    acc
    |> Map.keys
    |> Enum.sort
    |> Enum.map(&(acc[&1] |> Enum.reverse |> Enum.join))
  end


  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t, pos_integer) :: String.t
  def decode(str, 1    ), do: str
  def decode(str, rails)  do
    if String.length(str) <= rails, do: str,
    else: do_decode(str, rails)
  end

  defp do_decode(str, rails) do
    max_rail = rails - 1
    cycle_size = max_rail * 2
    len = String.length(str)
    cycles = div(len, cycle_size)
    leftover = rem(len, cycle_size)
    rail_map = prep_rails(String.graphemes(str),
                          0, max_rail, cycles, cycle_size, leftover, %{})
    decode_rails(rail_map, max_rail, 0, [])
    |> Enum.join
    |> String.reverse
  end


  defp prep_rails([], _, _, _, _, _, acc), do: acc

  defp prep_rails(chars, cur_rail_num, max_rail, cycles, cycle_size, leftover, acc)  do
    # last rail will TRY to take double portion, but only single is left
    rail_len = (if cur_rail_num > 0, do: cycles * 2, else: cycles) +
               cond do
                 leftover < cur_rail_num + 1          -> 0
                 leftover < cycle_size - cur_rail_num -> 1
                 true                                 -> 2
               end
    prep_rails(chars |> Enum.drop(rail_len),
               cur_rail_num + 1, max_rail, cycles, cycle_size, leftover,
               Map.put(acc, cur_rail_num, chars |> Enum.take(rail_len)))
  end


  defp decode_rails(rail_map, _, _, acc) when rail_map == %{}, do: acc

  defp decode_rails(rail_map, max_rail, char_num, acc) do
    cur_rail_num = rail_num(char_num, max_rail)
    [char|rest] = rail_map[cur_rail_num]
    new_map = if rest == [] do
                Map.delete(rail_map, cur_rail_num)
              else
                Map.put(rail_map, cur_rail_num, rest)
              end
    decode_rails(new_map, max_rail, char_num + 1, [char|acc])
  end

  defp rail_num(_       , 0       ), do: 0
  defp rail_num(char_num, max_rail)  do
    tmp = rem(char_num, max_rail * 2)
    if tmp <= max_rail, do: tmp, else: max_rail * 2 - tmp
  end

end
