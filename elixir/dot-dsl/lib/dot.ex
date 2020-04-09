defmodule Dot do
  defmacro graph([do: ast]) do
    {_ast, res} = Macro.prewalk(ast, %Graph{}, &handle_node/2)
    res
    |> sort_attrs()
    |> sort_nodes()
    |> Macro.escape()
  end

  # just don't hand back the node, cuz we may have handled some sub-nodes
  defp handle_node(node, graph), do: {:whatever, do_handle_node(node, graph)}

  defp do_handle_node({:__block__, [_attrs], contents}, graph),
    do: Enum.reduce(contents, graph, &do_handle_node/2)

  defp do_handle_node({:--, [_loc], [{a, _, _}, {b, _, attrs}]}, graph) do
    %Graph{graph | edges: [{a, b, make_attrs(attrs)} | graph.edges]}
  end

  defp do_handle_node({:graph, [_loc], attrs}, graph) do
    %Graph{graph | attrs: make_attrs(attrs) ++ graph.attrs}
  end

  defp do_handle_node({atom, [_loc], attrs}, graph) when is_atom(atom) do
    %Graph{graph | nodes: [{atom, make_attrs(attrs)} | graph.nodes]}
  end

  defp do_handle_node(node, _graph),
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
