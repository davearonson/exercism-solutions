defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t, pos_integer) :: String.t
  def encode(str, rails) do
    make_cycle(rails)
    |> Enum.zip(String.graphemes(str))
    |> encode_rails(%{})
    |> Enum.join
  end

  defp make_cycle(rails) do
    count_up_and_down(rails) |> Stream.cycle
  end

  defp count_up_and_down(n) when n < 3, do: (1..n)
  defp count_up_and_down(n), do: Enum.concat(1..n, (n-1)..2)

  defp encode_rails([{rail,char}|more], acc) do
    encode_rails(more, Map.put(acc, rail, [char|Map.get(acc, rail, [])]))
  end

  defp encode_rails([], acc) do
    acc
    |> Map.keys
    |> Enum.sort
    |> Enum.map(&(acc[&1] |> Enum.reverse |> Enum.join))
  end


  @accumulator_key "result"

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t, pos_integer) :: String.t
  def decode(str, 1    ), do: str
  def decode(str, rails)  do
    rail_map = split_rails(str, rails) |> Map.put(@accumulator_key, [])
    make_cycle(rails)
    |> Enum.take(String.length(str))
    |> Enum.reduce(rail_map, &get_char_from_rail/2)
    |> Map.get(@accumulator_key)
    |> Enum.join
    |> String.reverse
  end

  defp split_rails(str, num_rails) do
    cycle_size = num_rails * 2 - 2
    str_len = String.length(str)
    info = %{ cycle_size: cycle_size,
              num_cycles: div(str_len, cycle_size),
              left_over: rem(str_len, cycle_size)}
    do_split_rails(String.graphemes(str), info, 1, %{})
  end

  defp do_split_rails([], _, _, acc), do: acc

  defp do_split_rails(chars, info, rail_num, acc)  do
    rail_len = calc_rail_length(rail_num, info)
    do_split_rails(chars |> Enum.drop(rail_len), info, rail_num + 1, 
                   Map.put(acc, rail_num, chars |> Enum.take(rail_len)))
  end

  defp calc_rail_length(rail_num, info) do
    length_from_full_cycles(rail_num, info[:num_cycles]) +
    length_from_leftovers(rail_num, info[:left_over], info[:cycle_size])
  end

  defp length_from_full_cycles(1, num_cycles), do: num_cycles
  # last rail (if there are more than one)
  # will TRY to take double portion, but only single is left
  defp length_from_full_cycles(_, num_cycles), do: num_cycles * 2

  defp length_from_leftovers(rail_num, left_over, _)
    when left_over < rail_num, do: 0

  defp length_from_leftovers(rail_num, left_over, cycle_size)
    when left_over < cycle_size - rail_num, do: 1

  defp length_from_leftovers(_, _, _), do: 2

  # bit of a kluge, keeping the accumulator in the same map as the data,
  # but we only get to pass *one* accumulator and i haven't yet
  # figured out a better way to consume the chars in order,
  # than keeping the "rails" in a map and removing them as we go.
  defp get_char_from_rail(rail_num, rail_map) do
    [char|rest] = rail_map[rail_num]
    %{ rail_map | @accumulator_key => [char|rail_map[@accumulator_key]] }
    |> Map.put(rail_num, rest)
  end

end
