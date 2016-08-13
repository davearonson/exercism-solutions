defmodule Isogram do
  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t) :: boolean
  def isogram?(sentence) do
    ! repeats?(sentence |> String.graphemes
                        |> Enum.filter(&(&1 =~ ~r/^\pL$/u)),
               %{})
  end

  defp repeats?([],          _),    do: false
  defp repeats?([char|rest], sofar) do
    if sofar[char], do: true, else: repeats?(rest, Map.put(sofar, char, true))
  end

end
