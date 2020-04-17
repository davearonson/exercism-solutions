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
    letters =
      puzzle
      |> String.graphemes
      |> Enum.filter(&(&1 >= "A" and &1 <= "Z"))
      |> Enum.uniq
    nonzero =
      puzzle
      |> String.split(" == ")
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&hd/1)
    digits =
      (0..9)
      |> Enum.to_list
      |> Enum.map(&Integer.to_string/1)
    puzzle
    |> find_solution(letters, nonzero, digits)
  end

  defp find_solution(puzzle, letters, nonzero, digits) do
    Enum.find_value(digits,
                    &do_solve(puzzle, letters, nonzero,
                              # doing &1 separately and not constructing
                              # a list shaves about 10% off the time!
                              &1, List.delete(digits, &1)))
  end

  # if we're out of letters, see if it's right
  defp do_solve(puzzle, [], _, _, _) do
    {res, _} = Code.eval_string(puzzle)
    if res, do: %{}, else: nil
  end

  # if the current letter is forbidden to be nonzero,
  # and the current digit is zero, this branch is a dead end
  defp do_solve(_, [letter | _], [letter, _], "0", _), do: nil 
  defp do_solve(_, [letter | _], [_, letter], "0", _), do: nil

  # else recurse; if the final version works, add current letter & digit
  defp do_solve(puzzle, [letter | more_letters], nonzero,
                digit, more_digits) do
    new_puzzle = String.replace(puzzle, letter, digit)
    sol = find_solution(new_puzzle, more_letters, nonzero, more_digits)
    if is_nil(sol) do
      sol
      else
        Map.put(sol,
                letter |> String.to_charlist |> hd,
                digit |> String.to_integer)
      end
  end

end
