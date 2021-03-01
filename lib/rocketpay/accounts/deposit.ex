defmodule Rocketpay.Accounts.Deposit do
  alias Rocketpay.Accounts.Operation
  alias Rocketpay.Repo

  def call(params, user) do
    params
    |> transaction(user)
    |> run_transaction()
  end

  def transaction(params, user \\ nil), do: Operation.call(params, user, :deposit, &handle/2)

  defp handle({:ok, value}, balance), do: Decimal.add(balance, value)

  defp handle(:error, _balance), do: {:error, "Invalid deposit value"}

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{deposit_update_balance: account}} -> {:ok, account}
    end
  end
end
