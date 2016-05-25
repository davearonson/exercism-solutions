defmodule Teenager do

  @spec hey(String.t) :: String.t()
  def hey(input) do
    cond do
      # order is important here, as a shouted question is a shout
      is_silence?(input)  -> "Fine. Be that way!"
      is_shout?(input)    -> "Whoa, chill out!"
      is_question?(input) -> "Sure."
      true                -> "Whatever."
    end
  end


  defp is_silence?(input) do
    String.rstrip(input) == ""
  end

  defp is_shout?(input) do
    # need to ensure there is at least one letter; "3" is not a shout,
    # even though it matches its upcased version.
    # credit to someone else at the meetup for the alpha regex shortcut.
    String.upcase(input) == input && input =~ ~r/[[:alpha:]]/
  end

  defp is_question?(input) do
    String.ends_with?(input, "?")
  end

end
