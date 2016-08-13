defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare(a, b) do
    cond do
      a == b            -> :equal
      is_sublist?(a, b) -> :sublist
      is_sublist?(b, a) -> :superlist
      true              -> :unequal
    end
  end

  defp is_sublist?(_,   []         ), do: false
  defp is_sublist?(sub, [head|tail])  do
    case is_sublist_here?(sub, [head|tail]) do
      false    -> is_sublist?(sub, tail)
      :no_room -> false
      true     -> true
    end
  end

  defp is_sublist_here?([]    , _     ), do: true
  defp is_sublist_here?(_     , []    ), do: :no_room
  defp is_sublist_here?([h|t1], [h|t2]), do: is_sublist_here?(t1, t2)
  defp is_sublist_here?(_     , _     ), do: false

end
