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
                  extract_nonzero_letters(puzzle),
                  digits_list())
  end

  defp extract_letters(puzzle) do
    puzzle
      |> String.graphemes
      |> Enum.filter(&(&1 >= "A" and &1 <= "Z"))
      |> Enum.uniq
  end

  defp extract_nonzero_letters(puzzle) do
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

  defp find_solution(puzzle, [], _, _), do: check_solution(puzzle)
  defp find_solution(puzzle, letters, nonzero, digits) do
    Enum.find_value(digits,
                    &do_solve(puzzle, letters, nonzero, &1, digits -- [&1]))
  end

  defp check_solution(puzzle) do
    {res, _} = Code.eval_string(puzzle)
    if res, do: %{}, else: nil
  end

  defp do_solve(puzzle, [letter | more_letters], nonzero, digit, more_digits) do
    if digit == "0" and letter in nonzero do
      nil
    else
      new_puzzle = String.replace(puzzle, letter, digit)
      soln = find_solution(new_puzzle, more_letters, nonzero, more_digits)
      if soln do
        Map.put(soln, to_char(letter), String.to_integer(digit))
      else
        nil
      end
    end
  end

  defp do_solve(puzzle, [], _, _, _), do: check_solution(puzzle)

  defp to_char(letter) do
    letter
    |> String.to_charlist
    |> hd
  end

end
