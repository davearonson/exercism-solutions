defmodule GuessingGame do
  def compare(secret_number, guess \\ :no_guess)
  def compare(_,             :no_guess    ), do: "Make a guess"
  def compare(secret_number, secret_number), do: "Correct"
  def compare(secret_number, higher) when higher == secret_number + 1, do: "So close"
  def compare(secret_number, lower ) when lower  == secret_number - 1, do: "So close"
  def compare(secret_number, higher) when higher >  secret_number, do: "Too high"
  def compare(secret_number, lower ) when lower  <  secret_number, do: "Too low"
end
