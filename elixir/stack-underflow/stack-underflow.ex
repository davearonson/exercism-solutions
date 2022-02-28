defmodule RPNCalculator.Exception do
  defmodule DivisionByZeroError do
    defexception message: "division by zero occurred"
  end

  defmodule StackUnderflowError do
    @default_message "stack underflow occurred"
    defexception message: @default_message

    @impl true
    def exception([]), do: %StackUnderflowError{}
    def exception(value), do:
      %StackUnderflowError{message: "#{@default_message}, context: #{value}"}
  end

  def divide([]), do: raise StackUnderflowError, "when dividing"
  def divide([_]), do: raise StackUnderflowError, "when dividing"
  def divide([0|_rest]), do: raise DivisionByZeroError
  def divide([denom|[num|_rest]]), do: num / denom
end
