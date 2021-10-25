defmodule Alphametics do
  defstruct [:addends, :sum, :nonzeros]
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
    {struct, letters} = parse(puzzle)
    find_solution(struct,
                  letters,
                  Enum.to_list(0..9),
                  %{})
  end

  defp parse(puzzle) do
    # make them charlists to handle them as lists, for easy mapping to numbers,
    # and reverse them so we can destructure the list to sum and addends
    words =
      puzzle
      |> String.split(" ")
      |> Enum.filter(fn str -> String.match?(str, ~r/^[A-Z]+$/) end)
      |> Enum.map(&String.to_charlist/1)
      |> Enum.reverse
    [sum | addends] = words
    nonzeros =
      words
      |> Enum.map(&hd/1)
      |> Enum.uniq
    letters =
      words
      |> List.flatten
      |> Enum.uniq
    {%__MODULE__{addends: addends, sum: sum, nonzeros: nonzeros}, letters}
  end

  defp find_solution(puzzle, [], _, acc), do: check_solution(puzzle, acc)
  defp find_solution(puzzle, letters, digits, acc) do
    Enum.find_value(digits,
                    &do_solve(puzzle, letters, &1, digits -- [&1], acc))
  end

  defp check_solution(puzzle, acc) do
    try_sum =
      puzzle.addends
      |> Enum.map(&to_number(&1, acc))
      |> Enum.reduce(&Kernel.+/2)
    if try_sum == to_number(puzzle.sum, acc), do: acc  # else implicitly nil
  end

  defp to_number(chars, acc) do
    chars
    |> Enum.map(&acc[&1])
    |> Integer.undigits
  end

  defp do_solve(puzzle, [let | more_lets], digit, more_digits, acc) do
    if digit > 0 or let not in puzzle.nonzeros do
      find_solution(puzzle, more_lets, more_digits, Map.put(acc, let, digit))
    end  # else implicitly nil
  end

  defp do_solve(puzzle, [], _, _, acc), do: check_solution(puzzle, acc)

end
