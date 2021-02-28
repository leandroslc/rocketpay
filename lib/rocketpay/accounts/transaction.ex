defmodule Rocketpay.Accounts.Transaction do
  alias Ecto.Multi
  alias Rocketpay.Accounts.{Deposit, Withdraw}
  alias Rocketpay.Accounts.Transactions.Response, as: TransactionResponse
  alias Rocketpay.Repo

  def call(params) do
    %{"from" => from_id, "to" => to_id, "value" => value} = params

    withdraw_params = build_params(from_id, value)
    deposit_params = build_params(to_id, value)

    Multi.new()
    |> Multi.merge(fn _changes -> Withdraw.transaction(withdraw_params) end)
    |> Multi.merge(fn _changes -> Deposit.transaction(deposit_params) end)
    |> run_transaction()
  end

  defp build_params(id, value) do
    %{"id" => id, "value" => value}
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, changes} -> {:ok, get_response(changes)}
    end
  end

  defp get_response(changes) do
    %{
      withdraw_update_balance: from_account,
      deposit_update_balance: to_account
    } = changes

    TransactionResponse.build(from_account, to_account)
  end
end
