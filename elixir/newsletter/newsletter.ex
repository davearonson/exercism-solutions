defmodule Newsletter do
  def read_emails(path) do
    File.read!(path)
    |> String.split("\n")
    |> Enum.reject(fn(s) -> String.length(s) == 0 end)
  end

  def open_log(path) do
    File.open!(path, [:write])
  end

  def log_sent_email(pid, email) do
    IO.puts(pid, email)
  end

  def close_log(pid) do
    File.close(pid)
  end

  def send_newsletter(emails_path, log_path, send_fun) do
    emails = read_emails(emails_path)
    log_pid = open_log(log_path)
    Enum.each(emails, &(send_one_email(&1, send_fun, log_pid)))
    close_log(log_pid)
  end

  defp send_one_email(addr, send_fun, log_pid) do
    if send_fun.(addr) == :ok, do: log_sent_email(log_pid, addr)
  end
end
