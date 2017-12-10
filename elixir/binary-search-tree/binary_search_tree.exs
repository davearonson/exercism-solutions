defmodule BinarySearchTree do
  @type bst_node :: %{data: any, left: bst_node | nil, right: bst_node | nil}

  @doc """
  Create a new Binary Search Tree with root's value as the given 'data'
  """
  @spec new(any) :: bst_node
  def new(data) do
    %{data: data, left: nil, right: nil}
  end

  @doc """
  Creates and inserts a node with its value as 'data' into the tree.
  """
  @spec insert(bst_node, any) :: bst_node
  def insert(nil , data), do: new(data)
  def insert(tree, data)  do
    if data <= tree.data do
      %{tree | left: insert(tree.left, data) }
    else
      %{tree | right: insert(tree.right, data) }
    end
  end

  @doc """
  Traverses the Binary Search Tree in order and returns a list of each node's data.
  """
  @spec in_order(bst_node) :: [any]
  def in_order(tree) do
    # could do "in_order(tree.left) ++ [tree.data|in_order(tree.right)]",
    # (with in_order(nil) as []), but ++ is very inefficient.  this way is
    # sorta cheating, because it does not really *traverse* in order, but
    # does *return* the data in order.
    do_in_order(tree, [])
  end

  defp do_in_order(nil , acc), do: acc
  defp do_in_order(tree, acc)  do
    do_in_order(tree.left, [tree.data|do_in_order(tree.right, acc)])
  end

end
