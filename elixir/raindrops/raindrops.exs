defmodule Raindrops do

  @noises %{ 3 => "Pling", 5 => "Plang", 7 => "Plong" }

  @doc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """
  @spec convert(pos_integer) :: String.t
  def convert(number) do
    make_noises(number) || Integer.to_string(number)
  end

  defp make_noises(number) do
    @noises |> Map.keys
            |> Enum.filter(&(rem(number, &1) == 0))
            |> Enum.map_join(&(@noises[&1]))
            |> presence
  end

  defp presence("" ), do: nil
  defp presence(str), do: str

end
