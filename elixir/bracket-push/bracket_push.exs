defmodule BracketPush do
  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t) :: boolean
  def check_brackets(str) do
    do_check_brackets [],
                      (str |> String.split("", trim: true)
                           |> Enum.filter(&is_bracket?/1))
  end

  defp do_check_brackets(stack, []), do: Enum.empty? stack

  defp do_check_brackets([], [next_char | rest]) do
    do_check_brackets [next_char], rest
  end

  defp do_check_brackets([prior_char | more_stack],
                         [this_char  | more_chars]) do
    cond do
      is_match?(prior_char, this_char) ->
        do_check_brackets more_stack, more_chars
      is_opener?(prior_char) && is_closer?(this_char) ->
        false
      true ->
        do_check_brackets [this_char | [prior_char | more_stack]], more_chars
    end
  end

  @openers  "([{"
  @closers  "}])"  # does not need to align with openers; we sort when needed
  @brackets "#{@openers}#{@closers}"
  @pairs    @brackets |> String.split("", trim: true)
                      |> Enum.sort
                      |> Enum.chunk(2)
                      |> Enum.map(&Enum.join/1)

  defp is_bracket?(char), do: String.contains?(@brackets, char)

  defp is_match?(prior_char, this_char) do
    Enum.member?(@pairs, "#{prior_char}#{this_char}")
  end

  defp is_opener?(char), do: String.contains?(@openers, char)

  defp is_closer?(char), do: String.contains?(@closers, char)

end
