defmodule RPNCalculatorInspection do
  def start_reliability_check(calculator, input) do
    %{input: input, pid: spawn_link(fn -> calculator.(input) end) }
  end

  def await_reliability_check_result(%{pid: pid, input: input}, results) do
    receive do
      {:EXIT, ^pid, :normal} -> Map.put(results, input, :ok)
      {:EXIT, ^pid, _      } -> Map.put(results, input, :error)
    after
      100 -> Map.put(results, input, :timeout)
    end
  end

  def reliability_check(_, []), do: %{}
  def reliability_check(calculator, inputs) do
    was_trapping = Process.flag(:trap_exit, true)
    result =
      inputs
      |> Enum.map(&(start_reliability_check(calculator, &1)))
      |> Enum.map(&(await_reliability_check_result(&1, %{})))
      |> Enum.reduce(&Map.merge/2)
    Process.flag(:trap_exit, was_trapping)
    result
  end

  def correctness_check(_, []), do: []
  def correctness_check(calculator, inputs) do
    inputs
    |> Enum.map(&(Task.async(fn -> calculator.(&1) end)))
    |> Enum.map(&(Task.await(&1, 100)))
  end
end
