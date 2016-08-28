defmodule Matrix do
  @doc """
  Parses a string representation of a matrix
  to a list of rows
  """
  @spec rows(String.t()) :: [[integer]]
  def rows(str) do
    str
    |> String.split("\n")
    |> Enum.map(&String.split/1)
    |> Enum.map(&array_of_strings_to_ints/1)
  end

  defp array_of_strings_to_ints(arr) do
    do_array_of_strings_to_ints(arr, []) |> Enum.reverse
  end

  defp do_array_of_strings_to_ints([], acc), do: acc
  defp do_array_of_strings_to_ints([str|more], acc) do
    do_array_of_strings_to_ints(more, [String.to_integer(str)|acc])
  end

  @doc """
  Parses a string representation of a matrix
  to a list of columns
  """
  @spec columns(String.t()) :: [[integer]]
  def columns(str) do

  end

  @doc """
  Calculates all the saddle points from a string
  representation of a matrix
  """
  @spec saddle_points(String.t()) :: [{integer, integer}]
  def saddle_points(str) do

  end
end
