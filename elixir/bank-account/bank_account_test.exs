if !System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("account.exs", __DIR__)
end

ExUnit.start
ExUnit.configure exclude: :pending, trace: true

# The BankAccount module should support four calls:
#
# open_bank()
#   Called at the start of each test. Returns an account handle.
#
# close_bank(account)
#   Called at the end of each test.
#
# balance(account)
#   Get the balance of the bank account.
#
# update(account, amount)
#   Increment the balance of the bank account by the given amount.
#   The amount may be negative for a withdrawal.
#
# The initial value of the bank account should be 0.

defmodule BankAccountTest do
  use ExUnit.Case

  setup do
    account = BankAccount.open_bank
    { :ok, account: account }
  end

  test "initial balance is 0", %{account: account} do
    assert BankAccount.balance(account) == 0
  end

  test "incrementing and checking balance", %{account: account} do
    assert BankAccount.balance(account) == 0
    BankAccount.update(account, 10)
    assert BankAccount.balance(account) == 10
  end

  test "amount is added to balance", %{account: account} do
    assert BankAccount.balance(account) == 0
    BankAccount.update(account, 10)
    BankAccount.update(account, 10)
    assert BankAccount.balance(account) == 20
  end

  test "incrementing balance from another process then checking it from test process", %{account: account} do
    assert BankAccount.balance(account) == 0
    this = self()
    spawn(fn ->
      BankAccount.update(account, 20)
      send(this, :continue)
    end)
    receive do
      :continue -> :ok
    after
      1000 -> flunk("Timeout")
    end
    assert BankAccount.balance(account) == 20
  end

  test "closing makes it unavailable", %{account: account} do
    assert BankAccount.balance(account) == 0
    BankAccount.close_bank(account)
    this = self
    spawn(fn ->
      BankAccount.balance(account)
      send(this, :got_balance)
    end)
    receive do
      :got_balance -> flunk("Account is still available")
    after
      # TODO: figure out how to check that the msg didn't get thru, rather than
      # wait longer than deemed needed.  this approach leads to flaky tests.
      5 -> :ok
    end

  end

end
