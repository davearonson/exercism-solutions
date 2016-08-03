defmodule School do
  @moduledoc """
  Simulate students in a school.

  Each student is in a grade.
  """

  @doc """
  Add a student to a particular grade in school.
  """
  @spec add(Dict.t, String.t, pos_integer) :: Dict.t
  # changed param name not to conflict w/ function
  def add(db, name, grd) do
    Map.put(db, grd, [name | grade(db, grd)])
  end

  @doc """
  Return the names of the students in a particular grade.
  """
  @spec grade(Dict.t, pos_integer) :: [String]
  def grade(db, grade) do
    Map.get(db, grade, [])
  end

  @doc """
  Sorts the school by grade and name.
  """
  @spec sort(Dict) :: Dict.t
  def sort(db) do
    db |> Enum.sort  # returns it in key-sorted order, but AS TUPLES!
       |> Enum.map(&(sort_students(&1)))
       |> Enum.into(%{})
  end

  # takes grade as *tuple*, since that's what Enum.sort returns a list of :-(
  defp sort_students(grade), do: put_elem(grade, 1, Enum.sort(elem(grade, 1)))

end
