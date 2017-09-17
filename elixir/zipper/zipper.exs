defmodule BinTree do
  import Inspect.Algebra
  @moduledoc """
  A node in a binary tree.

  `value` is the value of a node.
  `left` is the left subtree (nil if no subtree).
  `right` is the right subtree (nil if no subtree).
  """
  @type t :: %BinTree{ value: any, left: BinTree.t | nil, right: BinTree.t | nil }
  defstruct value: nil, left: nil, right: nil

  # A custom inspect instance purely for the tests, this makes error messages
  # much more readable.
  #
  # BT[value: 3, left: BT[value: 5, right: BT[value: 6]]] becomes (3:(5::(6::)):)
  def inspect(%BinTree{value: v, left: l, right: r}, opts) do
    concat ["(", to_doc(v, opts),
            ":", (if l, do: to_doc(l, opts), else: ""),
            ":", (if r, do: to_doc(r, opts), else: ""),
            ")"]
  end
end

defmodule Zipper do
  alias BinTree, as: BT
  defstruct data: nil, path: nil, dirs: nil
  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BT.t) :: Z.t
  def from_tree(bt) do
    %Zipper{ data: bt, path: [bt], dirs: [] }
  end

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Z.t) :: BT.t
  def to_tree(z) do
    z.data
  end

  @doc """
  Get the value of the focus node.
  """
  @spec value(Z.t) :: any
  def value(%Zipper{path: [head|_rest]}) do
    head.value
  end

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Z.t) :: Z.t | nil
  def left(%Zipper{path: [%BT{left: nil}|_rest]}), do: nil
  def left(z=%Zipper{path: [%BT{left: lefty}|_rest]}) do
    %Zipper{ z | path: [lefty|z.path], dirs: [:left|z.dirs] }
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  def right(%Zipper{path: [%BT{right: nil}|_rest]}), do: nil
  def right(z=%Zipper{path: [%BT{right: righty}|_rest]}) do
    %Zipper{ z | path: [righty|z.path], dirs: [:right|z.dirs] }
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Z.t) :: Z.t
  def up(%Zipper{dirs: []}), do: nil
  def up(z=%Zipper{path: [_cur|path_rest], dirs: [_curdir|dirs_rest]}) do
    %Zipper{ z | path: path_rest, dirs: dirs_rest }
  end

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Z.t, any) :: Z.t
  def set_value(z=%Zipper{path: [head|rest]}, v) do
    new_head = %BT{ head | value: v }
    new_data = update_tree(rest, z.dirs, new_head)
    %Zipper{ z | data: new_data,
                 path: [new_head | rest] }
  end

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Z.t, BT.t) :: Z.t
  def set_left(z=%Zipper{path: [head|rest]}, l) do
    new_head = %BT{ head | left: l }
    new_data = update_tree(rest, z.dirs, new_head)
    %Zipper{ z | data: new_data, path: [new_head | rest] }
  end

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Z.t, BT.t) :: Z.t
  def set_right(z=%Zipper{path: [head|rest]}, l) do
    new_head = %BT{ head | right: l }
    new_data = update_tree(rest, z.dirs, new_head)
    %Zipper{ z | data: new_data, path: [new_head | rest] }
  end


  defp update_tree([], [], sub), do: sub
  defp update_tree([head|rest], [last_dir|prev_dirs], sub) do
    new_sub = case last_dir do
                :left -> %BT{ head | left: sub }
                :right -> %BT{ head | right: sub }
              end
    update_tree(rest, prev_dirs, new_sub)
  end

end
