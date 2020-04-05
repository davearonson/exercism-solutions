defmodule Forth do
  @opaque evaluator :: any

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

  defstruct [:stack, :words]

  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new() do
    %__MODULE__{stack: [], words: %{}}
  end

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t()) :: evaluator
  def eval(ev, s) do
    s
    |> String.split(~r/[^[:word:]\+\-\*\/]| /)  # Ogham space IS A WORD CHAR!
    |> Enum.reject(fn(s) -> s == "" end)
    |> Enum.map(&String.downcase/1)
    |> do_eval(ev)
  end

  defp do_eval(["+" | more_input],
               ev = %{stack: [n1 | [n2 | more_stack]]})
      when is_integer(n1) and is_integer(n2),
      do: do_eval(more_input, %{ev | stack: [n2 + n1 | more_stack]})

  defp do_eval(["-" | more_input],
               ev = %{stack: [n1 | [n2 | more_stack]]})
      when is_integer(n1) and is_integer(n2),
      do: do_eval(more_input, %{ev | stack: [n2 - n1 | more_stack]})

  defp do_eval(["*" | more_input],
               ev = %{stack: [n1 | [n2 | more_stack]]})
      when is_integer(n1) and is_integer(n2),
      do: do_eval(more_input, %{ev | stack: [n2 * n1 | more_stack]})

  defp do_eval(["/" | _more_input], %{stack: [0  | [n2 | _rest]]})
      when is_integer(n2),
      do: raise DivisionByZero

  defp do_eval(["/" | more_input],
               ev = %{stack: [n1 | [n2 | more_stack]]})
      when is_integer(n1) and is_integer(n2),
      do: do_eval(more_input, %{ev | stack: [div(n2, n1) | more_stack]})

  defp do_eval(["drop" |  more_input],
               ev = %{stack: [_top | more_stack]}),
      do: do_eval(more_input, %{ev | stack: more_stack})

  defp do_eval(["drop" | _more_input], %{stack: []}),
      do: raise StackUnderflow

  defp do_eval(["dup" | more_input],
               ev = %{stack: stack = [top | _rest]}),
      do: do_eval(more_input, %{ev | stack: [top | stack]})

  defp do_eval(["dup" | _more_input], %{stack: []}),
      do: raise StackUnderflow

  defp do_eval(["swap" | more_input],
               ev = %{stack: [top | [next | more_stack]]}),
      do: do_eval(more_input, %{ev | stack: [next | [top | more_stack]]})

  defp do_eval(["swap" | _more_input], %{stack: _eval}),
      do: raise StackUnderflow

  defp do_eval(["over" | more_input],
               ev = %{stack: stack = [_top | [next | _more_stack]]}),
      do: do_eval(more_input, %{ev | stack: [next | stack]})

  defp do_eval(["over" | _more_input], _eval),
      do: raise StackUnderflow

  defp do_eval([token | more_input],
               ev = %{stack: stack})  do
    cond do
      String.match?(token, ~r/^\d+$/) ->
        do_eval(more_input,
                %{ev | stack: [String.to_integer(token) | stack]})
      true ->
        raise ArgumentError
    end
  end

  defp do_eval([], ev), do: ev

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t()
  def format_stack(ev) do
    ev.stack
    |> Enum.reverse
    |> Enum.join(" ")
  end
end
