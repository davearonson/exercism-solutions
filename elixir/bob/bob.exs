defmodule Bob do

  @spec hey(String.t) :: String.t()
  def hey(input) do
    cond do
      # order is important here; a shouted question
      # is considered a question, not a shout.
      # (USED to be considered a shout though.  Harrumph.)
      silence?(input)  -> "Fine. Be that way!"
      question?(input) -> "Sure."
      shout?(input)    -> "Whoa, chill out!"
      true             -> "Whatever."
    end
  end


  defp silence?(input) do
    String.rstrip(input) == ""
  end

  defp shout?(input) do
    # need to ensure there is at least one letter; "3" is not a shout,
    # even though it matches its upcased version.
    # credit to someone else at the meetup for the alpha regex shortcut.
    String.upcase(input) == input && input =~ ~r/[[:alpha:]]/
  end

  defp question?(input) do
    String.ends_with?(input, "?")
  end

end
