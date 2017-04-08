use Bitwise
defmodule SecretHandshake do
  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    code
    |> Integer.to_string(2)
    |> String.graphemes
    |> Enum.reverse
    |> Enum.with_index
    |> Enum.map(&{elem(&1,0), 1 <<< elem(&1,1)})
    |> do_commands([])
  end

  @actions %{
    0b1 => "wink",
    0b10 => "double blink",
    0b100 => "close your eyes",
    0b1000 => "jump"
  }

  @action_nums @actions |> Map.keys

  defp do_commands([], acc), do: acc |> Enum.reverse

  defp do_commands([{"1",num}|tail], acc) when num in @action_nums do
    do_commands(tail, [@actions[num]|acc])
  end

  # note: depends on assumption that 16 is LAST!
  defp do_commands([{"1",16}|tail], acc), do: acc

  defp do_commands([_|tail], acc), do: do_commands(tail, acc)

end

