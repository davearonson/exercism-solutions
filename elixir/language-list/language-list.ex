defmodule LanguageList do
  def new() do
    []
  end

  def add(list, language) do
    [language | list]
  end

  def remove(list) do
    [_|rest] = list
    rest
  end

  def first(list) do
    [head|_] = list
    head
end

  def count(list), do: do_count(list, 0)
  defp do_count([]      , acc), do: acc
  defp do_count([_|rest], acc), do: do_count(rest, acc+1)

  def exciting_list?(list), do: do_exciting_list?(list)
  defp do_exciting_list?([]          ), do: false
  defp do_exciting_list?(["Elixir"|_]), do: true
  defp do_exciting_list?([_|rest]    ), do: do_exciting_list?(rest)
end
