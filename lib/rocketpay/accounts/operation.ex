defmodule Rocketpay.Accounts.Operation do
  alias Ecto.Multi
  alias Rocketpay.Account

  def call(params, operation) do
    %{"id" => id, "value" => value} = params

    Multi.new()
    |> Multi.run(:account, fn repo, _changes ->
      get_account(repo, id)
    end)
    |> Multi.run(:update_balance, fn repo, %{account: account} ->
      update_balance({repo, account, value, operation})
    end)
  end

  defp get_account(repo, id) do
    case repo.get(Account, id) do
      nil -> {:error, "Account not found"}
      account -> {:ok, account}
    end
  end

  defp update_balance(params) do
    {repo, account, value, operation} = params

    account
    |> handle_value(value, operation)
    |> update_account(repo, account)
  end

  defp handle_value(%Account{balance: balance}, value, operation) do
    value
    |> Decimal.cast()
    |> operation.(balance)
  end

  defp update_account({:error, _reason} = error, _repo, _account), do: error

  defp update_account(balance, repo, account) do
    params = %{balance: balance}

    account
    |> Account.changeset(params)
    |> repo.update()
  end
end
