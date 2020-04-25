defmodule Alphametics do
  @type puzzle :: binary
  @type solution :: %{required(?A..?Z) => 0..9}

  @doc """
  Takes an alphametics puzzle and returns a solution where every letter
  replaced by its number will make a valid equation. Returns `nil` when
  there is no valid solution to the given puzzle.

  ## Examples

      iex> Alphametics.solve("I + BB == ILL")
      %{?I => 1, ?B => 9, ?L => 0}

      iex> Alphametics.solve("A == B")
      nil
  """
  @spec solve(puzzle) :: solution | nil
  def solve(puzzle) do
    find_solution(puzzle,
                  extract_letters(puzzle),
                  extract_non0_letters(puzzle),
                  digits_list(),
                  %{})
  end

  defp extract_letters(puzzle) do
    puzzle
      |> String.graphemes
      |> Enum.filter(&(&1 >= "A" and &1 <= "Z"))
      |> Enum.uniq
  end

  defp extract_non0_letters(puzzle) do
    puzzle
      |> String.split(" ")
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&hd/1)
      |> Enum.filter(&(&1 >= "A" and &1 <= "Z"))
  end

  defp digits_list do
    (0..9)
    |> Enum.to_list
    |> Enum.map(&Integer.to_string/1)
  end

  defp find_solution(puzzle, [], _, _, acc), do: check_solution(puzzle, acc)
  defp find_solution(puzzle, letters, non0, digits, acc) do
    Enum.find_value(digits,
                    &do_solve(puzzle, letters, non0, &1, digits -- [&1], acc))
  end

  defp check_solution(puzzle, acc) do
    {res, _} =
      puzzle
      |> translate(acc)
      |> Code.eval_string
    if res, do: fixup_solution(acc), else: nil
  end

  defp translate(puzzle, acc),
    do: do_translate(puzzle, Map.keys(acc), Map.values(acc))

  defp do_translate(puzzle, [], _), do: puzzle
  defp do_translate(puzzle, [letter | letters], [digit | digits]) do
    do_translate(String.replace(puzzle, letter, digit), letters, digits)
  end

  defp fixup_solution(map) do
    for {letter, digit} <- map, into: %{},
      do: {to_char(letter), String.to_integer(digit)}
  end

  defp to_char(letter) do
    letter
    |> String.to_charlist
    |> hd
  end

  defp do_solve(puzzle, [let | more_lets], non0, digit, more_digits, acc) do
    if digit == "0" and let in non0 do
      nil
    else
      find_solution(puzzle, more_lets, non0, more_digits,
                    Map.put(acc, let, digit))
    end
  end

  defp do_solve(puzzle, [], _, _, _, acc), do: check_solution(puzzle, acc)

end
