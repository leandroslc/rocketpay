defmodule Rocketpay.Accounts.Withdraw do
  alias Rocketpay.Accounts.Operation
  alias Rocketpay.Repo

  def call(params, user) do
    params
    |> transaction(user)
    |> run_transaction()
  end

  def transaction(params, user), do: Operation.call(params, user, :withdraw, &handle/2)

  defp handle({:ok, value}, balance), do: Decimal.sub(balance, value)

  defp handle(:error, _balance), do: {:error, "Invalid withdraw value"}

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{withdraw_update_balance: account}} -> {:ok, account}
    end
  end
end
