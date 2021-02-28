defmodule Rocketpay do
  alias Rocketpay.Accounts.Deposit, as: AccountDeposit
  alias Rocketpay.Accounts.Transaction, as: AccountTransaction
  alias Rocketpay.Accounts.Withdraw, as: AccountWithdraw
  alias Rocketpay.Users.Create, as: UserCreate

  defdelegate create_user(params), to: UserCreate, as: :call
  defdelegate deposit(params), to: AccountDeposit, as: :call
  defdelegate transaction(params), to: AccountTransaction, as: :call
  defdelegate withdraw(params), to: AccountWithdraw, as: :call
end
