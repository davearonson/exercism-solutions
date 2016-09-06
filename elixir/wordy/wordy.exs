defmodule Wordy do

  @doc """
  Calculate the math problem in the sentence.
  """
  @spec answer(String.t) :: integer
  def answer(question) do
    # scan for hits composed of:
    # any string of non-digits (and stash it), a space,
    # and an optional minus sign followed by digits (and stash it and them).
    # at this point we're not bothering to validate the non-number part.
    pieces = Regex.scan(~r/([^\d]*) (-?\d+)/, question)
    # if we got no hits, or there is more (or less!) left over than a "?",
    # then the question is malformed. it may be malformed in other ways,
    # that will raise no-matching-clause errors below.
    if pieces == nil || remove_pieces(pieces, question) != "?" do
      raise ArgumentError
    end
    fixed = pieces |> Enum.map(&fixup/1)
    do_answer(fixed, nil)
  end

  defp remove_pieces([[whole_hit|_]|more], question) do
    remove_pieces(more, question |> String.replace(whole_hit, ""))
  end

  defp remove_pieces([], question), do: question

  # match on nil means it must be the very first thing.
  # anything else as first thing will also produce error
  # when we try to do math with it in the other defps.
  defp do_answer([["What is"|[number]]|more], nil) do
    do_answer(more, number)
  end

  defp do_answer([["plus"|[number]]|more], acc) do
    do_answer(more, acc + number)
  end

  defp do_answer([["minus"|[number]]|more], acc) do
    do_answer(more, acc - number)
  end

  defp do_answer([["multiplied by"|[number]]|more], acc) do
    do_answer(more, acc * number)
  end

  defp do_answer([["divided by"|[number]]|more], acc) do
    do_answer(more, acc / number)
  end

  defp do_answer([], acc), do: acc

  defp do_answer(_, _), do: raise ArgumentError

  defp fixup([_|[words|[number]]]) do
    [String.trim(words), String.to_integer(number)]
  end
end
