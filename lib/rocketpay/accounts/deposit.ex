defmodule Rocketpay.Accounts.Deposit do
  alias Rocketpay.Accounts.Operation
  alias Rocketpay.Repo

  def call(params) do
    params
    |> Operation.call(&handle/2)
    |> run_transaction()
  end

  defp handle({:ok, value}, balance), do: Decimal.add(balance, value)

  defp handle(:error, _balance), do: {:error, "Invalid deposit value"}

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{update_balance: account}} -> {:ok, account}
    end
  end
end
