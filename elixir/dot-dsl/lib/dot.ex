defmodule Dot do
  defmacro graph(ast) do
    walk(ast, %Graph{})
    |> sort_attrs()
    |> sort_nodes()
    |> Macro.escape()
  end

  defp walk({:do, {:__block__, _, contents}}, graph) do
    walk(contents, graph)
  end

  defp walk({:do, contents}, graph), do: walk(contents, graph)

  defp walk(list, graph) when is_list(list),
    do: Enum.reduce(list, graph, &walk/2)

  defp walk(non_tuple, _graph) when not is_tuple(non_tuple),
    do: raise(ArgumentError)

  defp walk(missized_tuple, _graph) when tuple_size(missized_tuple) != 3,
    do: raise(ArgumentError)

  defp walk({:--, [_loc], [{node_a, _, _}, {node_b, _, attrs}]}, graph) do
    %Graph{graph | edges: [{node_a, node_b, make_attrs(attrs)} | graph.edges]}
  end

  defp walk({:graph, [_loc], attrs}, graph) do
    %Graph{graph | attrs: make_attrs(attrs) ++ graph.attrs}
  end

  defp walk({atom, [_loc], attrs}, graph) do
    %Graph{graph | nodes: [{atom, make_attrs(attrs)} | graph.nodes]}
  end

  defp make_attrs([attrs]) do
    if Keyword.keyword?(attrs), do: attrs, else: raise(ArgumentError)
  end

  defp make_attrs(nil), do: []
  defp make_attrs(_)  , do: raise(ArgumentError)

  defp sort_attrs(graph = %{attrs: [_any | _more]}),
    do: %Graph{graph | attrs: Enum.sort(graph.attrs)}

  defp sort_attrs(graph), do: graph

  defp sort_nodes(graph = %{nodes: [_any | _more]}),
    do: %Graph{graph | nodes: Enum.sort(graph.nodes)}

  defp sort_nodes(graph), do: graph
end
