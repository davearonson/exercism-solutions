defmodule TopSecret do
  def to_ast(string) do
    {:ok, ast} = Code.string_to_quoted(string)
    ast
  end

  def decode_secret_message_part(ast, acc) do
    new_acc =
      # need to check for tuples cuz prewalk does others too :-P
      if is_tuple(ast) && elem(ast, 0) in ~w(def defp)a do
        [get_secret_part(ast)|acc]
      else
        acc
      end
    {ast, new_acc}
  end

  defp get_secret_part(ast) do
    func_def = ast |> elem(2) |> hd
    name = func_def |> elem(0)
    if name == :when do
      get_secret_part(func_def)
    else
      meta = func_def |> elem(2)
      arity = if meta, do: Enum.count(meta), else: 0
      String.slice(Atom.to_string(name), 0, arity)
    end
  end

  def decode_secret_message(string) do
    ast = to_ast(string)
    Macro.prewalk(ast, [], &decode_secret_message_part/2)
    |> elem(1)
    |> Enum.reverse
    |> Enum.join
  end
end
