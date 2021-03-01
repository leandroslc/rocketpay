defmodule Rocketpay do

  defdelegate deposit(params, user),
    to: Rocketpay.Accounts.Deposit,
    as: :call

  defdelegate transaction(params, user),
    to: Rocketpay.Accounts.Transaction,
    as: :call

  defdelegate withdraw(params, user),
    to: Rocketpay.Accounts.Withdraw,
    as: :call

  defdelegate create_user(params),
    to: Rocketpay.Users.Create,
    as: :call

  defdelegate find_user(params),
    to: Rocketpay.Users.Find,
    as: :call
end
