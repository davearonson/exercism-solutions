defmodule ListOps do
  # Please don't use any external modules (especially List) in your
  # implementation. The point of this exercise is to create these basic functions
  # yourself.
  #
  # Note that `++` is a function from an external module (Kernel, which is
  # automatically imported) and so shouldn't be used either.

  @spec count(list) :: non_neg_integer
  def count(l) do
    do_count(l, 0)
  end
  defp do_count([], acc), do: acc
  defp do_count([_|tail], acc), do: do_count(tail, acc + 1)

  @spec reverse(list) :: list
  def reverse(l) do
    do_reverse(l, [])
  end
  defp do_reverse([], acc), do: acc
  defp do_reverse([head|tail], acc), do: do_reverse(tail, [head | acc])

  @spec map(list, (any -> any)) :: list
  def map(l, f) do
    do_map(l, f, [])
  end
  defp do_map([], _, acc), do: acc
  defp do_map([head|tail], f, acc), do: [f.(head) | do_map(tail, f, acc)]

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f) do
    do_filter(l, f, [])
  end
  defp do_filter([], _, acc), do: acc
  defp do_filter([head|tail], f, acc) do
    prepend_if_true(head, do_filter(tail, f, acc), f.(head))
  end
  defp prepend_if_true(item, list, decider) do
    if decider, do: [item | list], else: list
  end

  @type acc :: any
  @spec reduce(list, acc, ((any, acc) -> acc)) :: acc
  def reduce(l, acc, f) do
    do_reduce(l, acc, f)
  end
  defp do_reduce([], acc, _), do: acc
  defp do_reduce([head|tail], acc, f), do: do_reduce(tail, f.(head, acc), f)

  @spec append(list, list) :: list
  def append(a, b) do
    do_append(a, b)
  end
  defp do_append([], acc), do: acc
  defp do_append([head|tail], acc), do: [head | do_append(tail, acc)]

  @spec concat([[any]]) :: [any]
  def concat(ll) do
    do_concat(ll, [])
  end
  defp do_concat([], acc), do: acc
  defp do_concat([head|tail], acc), do: append(head, do_concat(tail, acc))
end
