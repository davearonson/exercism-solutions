defmodule RPNCalculator do
  def calculate!(stack, operation) do
    operation.(stack)
  end

  def calculate(stack, operation) do
    try do
      calculate!(stack, operation)
      {:ok, "operation completed"}
    rescue
      _e -> :error
    end
  end

  def calculate_verbose(stack, operation) do
    try do
      calculate!(stack, operation)
      {:ok, "operation completed"}
    rescue
      e -> {:error, e.message }
    end
  end
end
