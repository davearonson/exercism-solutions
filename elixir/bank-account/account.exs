defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank() do
    spawn(fn ->
      BankAccount.wait_for_msgs
    end)
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account) do
    # this isn't actually USED in the tests, but since it's here....
    send(account, {:close})
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do
    send(account, {:balance, self})
    receive do
      whatever -> whatever
    end
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount) do
    send(account, {:update, amount})
  end

  def wait_for_msgs(balance \\ 0) do
    receive do
      {:balance, asker} ->
        send(asker, balance)
        wait_for_msgs(balance)
      {:close} ->
        nil
      {:update, amount} ->
        wait_for_msgs(balance + amount)
    end
  end

end
