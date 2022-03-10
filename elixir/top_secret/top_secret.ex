defmodule TopSecret do
  def to_ast(string), do: Code.string_to_quoted!(string)

  def decode_secret_message_part({op, _, [func_def|_]} = ast, acc)
      when op in ~w(def defp)a do
      {ast, [get_secret_part(func_def)|acc] }
  end
  def decode_secret_message_part(ast, acc), do: {ast, acc}

  defp get_secret_part({:when, _, [meta|_]}), do:
    get_secret_part(meta)

  defp get_secret_part({name, _, nil}), do:
    name |> Atom.to_string |> String.slice(0, 0)

  defp get_secret_part({name, _, meta}), do:
    name |> Atom.to_string |> String.slice(0, Enum.count(meta))

  def decode_secret_message(string) do
    Macro.prewalk(to_ast(string), [], &decode_secret_message_part/2)
    |> elem(1)
    |> Enum.reverse
    |> Enum.join
  end
end
