defmodule RunLengthEncoder do
  @doc """
  Generates a string where consecutive elements are represented as
  a data value and count.
  "HORSE" => "1H1O1R1S1E"
  For this example, assume all input are strings,
  that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "1H1O1R1S1E" => "HORSE"
  """
  @spec encode(String.t) :: String.t
  def encode(string) do
    string |> String.split("") |> do_encode("", 0, "")
  end

  @spec decode(String.t) :: String.t
  def decode(string) do
    Regex.scan(~r/\d+\w/, string) |> Enum.map(&Enum.at(&1, 0))
                                  |> Enum.map(&reconstitute/1)
                                  |> Enum.join
  end


  defp do_encode([], acc, _, ""), do: acc

  defp do_encode([], acc, count, char), do: final_acc(acc, count, char)

  defp do_encode([head|tail], acc, 0, _) do
    do_encode(tail, acc, 1, head)
  end

  defp do_encode([head|tail], acc, count, head) do
    do_encode(tail, acc, count + 1, head)
  end

  defp do_encode([head|tail], acc, count, char) do
    do_encode(tail, final_acc(acc, count, char), 1, head)
  end


  defp final_acc(acc, count, char) do
    if count > 0, do: "#{acc}#{count}#{char}", else: acc
  end


  defp reconstitute(encoded) do
    String.duplicate(String.last(encoded),
                     Regex.scan(~r/^\d+/, encoded)
                     # there should be a better way to do this, like .at(0,0)
                     |> Enum.at(0) |> Enum.at(0)
                     |> String.to_integer)
  end

end
