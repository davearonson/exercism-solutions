defmodule Acronym do
  @doc """
  Generate an acronym from a string. 
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t) :: String.t()
  def abbreviate(string) do
    string |> String.split
           |> Enum.map(&extract_acronym_parts/1)
           |> Enum.join
           |> String.upcase
  end


  defp extract_acronym_parts(""), do: ""

  defp extract_acronym_parts(string) do
    string |> String.split("") |> do_extract_acronym_parts
  end


  # use this to avoid need for a temp var to hold the chars
  defp do_extract_acronym_parts([head|tail]) do
    "#{head}#{extract_capitals(tail)}"
  end


  defp extract_capitals([]), do: ""

  defp extract_capitals([head|tail]) do
    "#{char_if_uppercase(head)}#{extract_capitals(tail)}"
  end


  defp char_if_uppercase(char) do
    if is_uppercase?(char), do: char, else: ""
  end


  defp is_uppercase?(char), do: char =~ ~r/[[:upper:]]/

end
