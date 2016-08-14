defmodule Garden do
  @doc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """

  @default_kids ~w(alice bob charlie david eve fred ginny harriet ileana joseph kincaid larry)a

  @spec info(String.t(), list) :: map
  def info(info_string, student_names \\ @default_kids) do
    [row1, row2] = String.split(info_string, "\n")
    do_match_with_flowers(Enum.sort(student_names),
                          String.graphemes(row1),
                          String.graphemes(row2),
                          %{})
  end

  defp do_match_with_flowers([], [], [], sofar), do: sofar

  defp do_match_with_flowers([kid|rest], [], [], sofar) do
    do_match_with_flowers(rest, [], [], Map.put(sofar, kid, {}))
  end

  defp do_match_with_flowers([kid|rest], [f1|[f2|row1]], [f3|[f4|row2]], sofar) do
    do_match_with_flowers(rest, row1, row2,
                          Map.put(sofar, kid,
                                  [f1, f2, f3, f4]
                                    |> Enum.map(&(to_flower(&1)))
                                    |> List.to_tuple))
  end

  @flowers %{ "G" => :grass, "C" => :clover, "R" => :radishes, "V" => :violets }

  defp to_flower(char), do: @flowers[char]

end
