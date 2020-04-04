defmodule Forth do

  defmodule DivisionByZero do
    defexception message: "division by zero"
  end

  defmodule StackUnderflow do
    defexception message: "stack underflow"
  end


  @opaque evaluator :: any

  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new() do
    []
  end

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t()) :: evaluator
  def eval(ev, s) do
    s
    |> String.split(~r/[^0-9\+\-\*\/A-Za-z]/)
    |> Enum.reject(fn(s) -> s == "" end)
    |> Enum.reduce(ev, fn(tkn, acc) -> do_eval(String.downcase(tkn), acc) end)
  end

  defp do_eval("+", [n1 | [n2 | rest]]) when is_integer(n1) and is_integer(n2),
      do: [n2 + n1 | rest]
  defp do_eval("-", [n1 | [n2 | rest]]) when is_integer(n1) and is_integer(n2),
      do: [n2 - n1 | rest]
  defp do_eval("*", [n1 | [n2 | rest]]) when is_integer(n1) and is_integer(n2),
      do: [n2 * n1 | rest]
  defp do_eval("/", [0  | [n2 | rest]]) when is_integer(n2),
      do: raise DivisionByZero
  defp do_eval("/", [n1 | [n2 | rest]]) when is_integer(n1) and is_integer(n2),
      do: [div(n2, n1) | rest]

  defp do_eval("drop", [_top | rest]), do: rest
  defp do_eval("drop", []), do: raise StackUnderflow

  defp do_eval("dup", stack = [top | rest]), do: [top | stack]
  defp do_eval("dup", []), do: raise StackUnderflow

  defp do_eval("swap", [top | [next | rest]]), do: [next | [top | rest]]
  defp do_eval("swap", [top | rest]), do: raise StackUnderflow
  defp do_eval("swap", []), do: raise StackUnderflow

  defp do_eval("over", [top | [next | rest]]), do: [next | [top | [next | rest]]]
  defp do_eval("over", [top | rest]), do: raise StackUnderflow
  defp do_eval("over", []), do: raise StackUnderflow

  defp do_eval(token, ev)  do
    cond do
      String.match?(token, ~r/^\d+$/) -> [String.to_integer(token) | ev]
      true                            -> raise ArgumentError, message: "WTF - '#{token}'; stack = '#{format_stack(ev)}'"
    end
  end

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t()
  def format_stack(ev) do
    ev
    |> Enum.reverse
    |> Enum.join(" ")
  end

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end

  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end
end
