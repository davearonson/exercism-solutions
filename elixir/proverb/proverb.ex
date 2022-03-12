defmodule Proverb do
  @doc """
  Generate a proverb from a list of strings.
  """
  @spec recite(strings :: [String.t()]) :: String.t()
  def recite([]), do: ""
  def recite(strings) do
    fors = do_recite(strings, [])
    last = "And all for the want of a #{hd(strings)}.\n"
    [last|fors] |> Enum.reverse |> Enum.join
    # could alternately reverse in the base-case of do_recite,
    # and append [last], but prepending is more efficient/Elixirish
  end

  defp do_recite([first|rest = [second|_]], acc) do
    new_line = "For want of a #{first} the #{second} was lost.\n"
    do_recite(rest, [new_line|acc])
  end
  defp do_recite(_, acc), do: acc
end
