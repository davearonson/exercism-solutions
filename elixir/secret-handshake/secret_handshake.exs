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
    |> Enum.reverse  # do this NOW so 16 takes effect AFTER stuff is in it
    |> Enum.with_index
    |> process_slot([])
  end

  # Could either reverse it now OR build it w/ ++ which is much slower.
  # Was trying to think of a way to do zero or one reversals,
  # not two or three, but not coming up with anything I liked.
  defp process_slot([], acc), do: acc |> Enum.reverse
  defp process_slot([{"0", _idx}|tail], acc), do: process_slot(tail, acc)
  defp process_slot([{"1",  idx}|tail], acc), do: do_command(idx, tail, acc)

  defp do_command(0, tail, acc), do: process_slot(tail, ["wink"|acc])
  defp do_command(1, tail, acc), do: process_slot(tail, ["double blink"|acc])
  defp do_command(2, tail, acc), do: process_slot(tail, ["close your eyes"|acc])
  defp do_command(3, tail, acc), do: process_slot(tail, ["jump"|acc])
  defp do_command(4, tail, acc), do: process_slot(tail, acc |> Enum.reverse)
  defp do_command(_,    _, acc), do: acc

end

