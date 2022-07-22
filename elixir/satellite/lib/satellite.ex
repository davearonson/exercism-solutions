defmodule Satellite do
  @typedoc """
  A tree, which can be empty, or made from a left branch, a node and a right branch
  """
  @type tree :: {} | {tree, any, tree}

  @doc """
  Build a tree from the elements given in a pre-order and in-order style
  """
  @spec build_tree(preorder :: [any], inorder :: [any]) :: {:ok, tree} | {:error, String.t()}

  def build_tree([], []), do: {:ok, {}}
  def build_tree(preorder, inorder) do
    cond do
      length(preorder) != length(inorder) ->
        {:error, "traversals must have the same length"}
      preorder != Enum.uniq(preorder) or inorder != Enum.uniq(inorder) ->
        {:error, "traversals must contain unique items"}
      Enum.sort(preorder) != Enum.sort(inorder) ->
        {:error, "traversals must have the same elements"}
      true ->
        do_build_tree(preorder, inorder)
    end
  end

  defp do_build_tree(preorder = [root|_rest], inorder) do
    {left_inorder, [root|right_inorder]} =
      Enum.split_while(inorder, &(&1 != root))
    left_preorder  = Enum.filter(preorder, &(Enum.member?(left_inorder, &1)))
    right_preorder = Enum.filter(preorder, &(Enum.member?(right_inorder, &1)))
    with {:ok, left}  <- build_tree(left_preorder, left_inorder),
         {:ok, right} <- build_tree(right_preorder, right_inorder)
    do
      {:ok, {left, root, right}}
    end
  end
end
