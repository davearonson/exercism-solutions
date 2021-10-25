defmodule Dot do
  defmacro graph([do: ast]) do
    {_ast, res} = Macro.prewalk(ast, %Graph{}, &handle_node/2)
    res
    |> sort_attrs()
    |> sort_nodes()
    |> Macro.escape()
  end

  # pass block thru unchanged, to let prewalk handle contents; on all others,
  # return empty ast to prevent prewalk from processing contents further

  defp handle_node(n = {:__block__, [_loc], _contents}, graph), do: {n, graph}

  defp handle_node({:--, [_loc], [{a, _, _}, {b, _, attrs}]}, graph),
    do: {{}, %Graph{graph | edges: [{a, b, make_attrs(attrs)} | graph.edges]}}

  defp handle_node({:graph, [_loc], attrs}, graph),
    do: {{},
         %Graph{graph | attrs: Keyword.merge(graph.attrs, make_attrs(attrs))}}

  defp handle_node({atom, [_loc], attrs}, graph) when is_atom(atom),
    do: {{}, %Graph{graph | nodes: [{atom, make_attrs(attrs)} | graph.nodes]}}

  defp handle_node(node, _graph),
    do: raise(ArgumentError, message: "Dunno how to handle #{inspect(node)}")

  defp make_attrs([attrs]) do
    if Keyword.keyword?(attrs) do
      attrs
    else
      raise(ArgumentError,
            message: "Expected keyword list, got #{inspect(attrs)}")
    end
  end

  defp make_attrs(nil), do: []

  defp make_attrs(arg),
    do: raise(ArgumentError, "Expected [kw list] or nil, got #{inspect(arg)}")

  defp sort_attrs(graph = %{attrs: [_any | _more]}),
    do: %Graph{graph | attrs: Enum.sort(graph.attrs)}

  defp sort_attrs(graph), do: graph

  defp sort_nodes(graph = %{nodes: [_any | _more]}),
    do: %Graph{graph | nodes: Enum.sort(graph.nodes)}

  defp sort_nodes(graph), do: graph
end
