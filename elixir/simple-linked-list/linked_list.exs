defmodule LinkedList do
  @opaque t :: tuple()

  defstruct datum: nil, next: nil

  @doc """
  Construct a new LinkedList
  """
  @spec new() :: t
  def new(), do: nil

  @doc """
  Push an item onto a LinkedList
  """
  @spec push(t, any()) :: t
  def push(list, elem), do: %LinkedList{datum: elem, next: list}

  @doc """
  Calculate the length of a LinkedList
  """
  @spec length(t) :: non_neg_integer()
  def length(%LinkedList{next: next}), do: LinkedList.length(next) + 1
  def length(nil), do: 0

  @doc """
  Determine if a LinkedList is empty
  """
  @spec empty?(t) :: boolean()
  def empty?(%LinkedList{}), do: false
  def empty?(nil), do: true

  @doc """
  Get the value of a head of the LinkedList
  """
  @spec peek(t) :: {:ok, any()} | {:error, :empty_list}
  def peek(%LinkedList{datum: datum}), do: {:ok, datum}
  def peek(nil), do: {:error, :empty_list}

  @doc """
  Get tail of a LinkedList
  """
  @spec tail(t) :: {:ok, t} | {:error, :empty_list}
  def tail(%LinkedList{next: next}), do: {:ok, next}
  def tail(nil), do: {:error, :empty_list}

  @doc """
  Remove the head from a LinkedList
  """
  @spec pop(t) :: {:ok, any(), t} | {:error, :empty_list}
  def pop(%LinkedList{datum: datum, next: next}), do: {:ok, datum, next}
  def pop(nil), do: {:error, :empty_list}

  @doc """
  Construct a LinkedList from a stdlib List
  """
  @spec from_list(list()) :: t
  def from_list(list), do: do_from_list(Enum.reverse(list), nil)
  defp do_from_list([head|tail], acc) do
    do_from_list(tail, %LinkedList{datum: head, next: acc})
  end
  defp do_from_list([], acc), do: acc

  @doc """
  Construct a stdlib List LinkedList from a LinkedList
  """
  @spec to_list(t) :: list()
  def to_list(list), do: do_to_list(list, []) |> Enum.reverse
  defp do_to_list(%LinkedList{datum: datum, next: next}, acc) do
    do_to_list(next, [datum|acc])
  end
  defp do_to_list(nil, acc), do: acc

  @doc """
  Reverse a LinkedList
  """
  @spec reverse(t) :: t
  def reverse(list), do: do_reverse(list, nil)
  defp do_reverse(%LinkedList{datum: datum, next: next}, acc) do
    do_reverse(next, %LinkedList{datum: datum, next: acc})
  end
  defp do_reverse(nil, acc), do: acc
end
