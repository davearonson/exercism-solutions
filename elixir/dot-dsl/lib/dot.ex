defmodule Dot do
  defmacro graph(ast) do
    walk(%Graph{}, ast) |> Macro.escape
  end

  defp walk(graph, {:do, {:__block__, _, contents}}) do
    walk(graph, contents)
  end

  defp walk(graph, {:do, contents}), do: walk(graph, contents)

  defp walk(graph, [item | more]  ), do: walk(graph, item) |> walk(more)
  defp walk(graph, []             ), do: graph
  # why doesn't Enum.reduce(list, graph, &walk/2) work,
  # even after ensuring that it is indeed a list?!

  defp walk(_graph, non_tuple) when not is_tuple(non_tuple),
      do: raise ArgumentError

  defp walk(_graph, missized_tuple) when tuple_size(missized_tuple) != 3,
      do: raise ArgumentError

  defp walk(graph, {:--, [_loc], [{node_a, _, _}, {node_b, _, attrs}]}) do
    %Graph{graph | edges: [{node_a, node_b, make_attrs(attrs)} | graph.edges]}
  end

  defp walk(graph, {:graph, [_loc], attrs}) do
    %Graph{graph | attrs: Enum.sort(make_attrs(attrs) ++ graph.attrs)}
  end

  defp walk(graph, {atom, [_loc], attrs}) do
    %Graph{graph | nodes: Enum.sort([{atom, make_attrs(attrs)} | graph.nodes])}
  end

  defp make_attrs([attrs]) do
    if Keyword.keyword?(attrs), do: attrs, else: raise ArgumentError
  end
  defp make_attrs(nil), do: []
  defp make_attrs(_)  , do: raise ArgumentError
end
