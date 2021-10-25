defmodule TakeANumber do
  def start(), do: spawn(&loop/0)

  defp loop(last_num \\ 0) do
    receive do
      {:report_state, sender_pid} ->
        send(sender_pid, last_num)
        loop(last_num)
      {:take_a_number, sender_pid} ->
        new_last_num = last_num + 1
        send(sender_pid, new_last_num)
        loop(new_last_num)
      :stop ->
        nil
      _ ->
        loop(last_num)
    end
  end
end
