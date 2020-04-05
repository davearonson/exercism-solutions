defmodule Forth do

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
  @opaque evaluator :: %__MODULE__{}

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
  # Elixir thinks Ogham space is a WORD CHAR, WTF?!
  @spec eval(evaluator, String.t()) :: evaluator
  def eval(ev, s) do
    s
    |> String.split(~r/[^[:word:]\+\-\*\/\:\;]| /)
    |> Enum.reject(fn(s) -> s == "" end)
    |> Enum.map(&String.downcase/1)
    |> do_eval(ev)
  end

  defp do_eval([token | more_input], ev) do
    if Map.has_key?(ev.words, token) do
      do_eval(more_input, do_eval(ev.words[token], ev))
    else
      plain_eval(token, more_input, ev)
    end
  end

  defp do_eval([], ev), do: ev

  defp plain_eval("+", more_input,
                  ev = %{stack: [n1 | [n2 | more_stack]]})
      when is_integer(n1) and is_integer(n2),
      do: do_eval(more_input, %{ev | stack: [n2 + n1 | more_stack]})

  defp plain_eval("-", more_input,
                  ev = %{stack: [n1 | [n2 | more_stack]]})
      when is_integer(n1) and is_integer(n2),
      do: do_eval(more_input, %{ev | stack: [n2 - n1 | more_stack]})

  defp plain_eval("*", more_input,
                  ev = %{stack: [n1 | [n2 | more_stack]]})
      when is_integer(n1) and is_integer(n2),
      do: do_eval(more_input, %{ev | stack: [n2 * n1 | more_stack]})

  defp plain_eval("/", _more_input, %{stack: [0  | [n2 | _rest]]})
      when is_integer(n2),
      do: raise DivisionByZero

  defp plain_eval("/", more_input,
                  ev = %{stack: [n1 | [n2 | more_stack]]})
      when is_integer(n1) and is_integer(n2),
      do: do_eval(more_input, %{ev | stack: [div(n2, n1) | more_stack]})

  defp plain_eval("drop", more_input,
                  ev = %{stack: [_top | more_stack]}),
      do: do_eval(more_input, %{ev | stack: more_stack})

  defp plain_eval("drop", _more_input, %{stack: []}),
      do: raise StackUnderflow

  defp plain_eval("dup", more_input,
                  ev = %{stack: stack = [top | _rest]}),
      do: do_eval(more_input, %{ev | stack: [top | stack]})

  defp plain_eval("dup", _more_input, %{stack: []}),
      do: raise StackUnderflow

  defp plain_eval("swap", more_input,
                  ev = %{stack: [top | [next | more_stack]]}),
      do: do_eval(more_input, %{ev | stack: [next | [top | more_stack]]})

  defp plain_eval("swap", _more_input, %{stack: _eval}),
      do: raise StackUnderflow

  defp plain_eval("over", more_input,
                  ev = %{stack: stack = [_top | [next | _more_stack]]}),
      do: do_eval(more_input, %{ev | stack: [next | stack]})

  defp plain_eval("over", _more_input, _eval),
      do: raise StackUnderflow

  defp plain_eval(":", [word | more_input], ev) do
    if String.match?(word, ~r/^\d+$/), do: raise InvalidWord
    [rest_of_input, meaning] = do_define(more_input, [])
    do_eval(rest_of_input, %{ev | words: Map.put(ev.words, word, meaning)})
  end

  defp plain_eval(token, more_input, ev = %{stack: stack})  do
    cond do
      String.match?(token, ~r/^\d+$/) ->
        do_eval(more_input,
                %{ev | stack: [String.to_integer(token) | stack]})
      true ->
        raise UnknownWord
    end
  end

  defp do_define([";" | more_input], meaning) do
    [more_input, Enum.reverse(meaning)]
  end

  defp do_define([token | more_input], meaning) do
    do_define(more_input, [token | meaning])
  end

  defp do_define([], _meaning), do: raise ArgumentError

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
