defmodule Rocketpay.Accounts.Operation do
  alias Ecto.Multi
  alias Rocketpay.{Account, User}

  def call(params, user \\ nil, name, operation) do
    %{"id" => id, "value" => value} = params

    get_account_operation = operation_name(name, :account)

    Multi.new()
    |> Multi.run(get_account_operation, fn repo, _changes ->
      get_account(repo, id)
    end)
    |> Multi.run(operation_name(name, :check_owner), fn _repo, changes ->
      account = Map.get(changes, get_account_operation)
      check_owner(account, user)
    end)
    |> Multi.run(operation_name(name, :update_balance), fn repo, changes ->
      account = Map.get(changes, get_account_operation)
      update_balance({repo, account, value, operation})
    end)
  end

  defp get_account(repo, id) do
    case repo.get(Account, id) do
      nil -> {:error, "Account not found"}
      account -> {:ok, account}
    end
  end

  defp check_owner(%Account{} = account, nil), do: {:ok, account}

  defp check_owner(%Account{user_id: user_id} = account, %User{id: id}) do
    if user_id == id do
      {:ok, account}
    else
      {:error, "Account not found"}
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

  defp operation_name(identifier, name) do
    "#{Atom.to_string(identifier)}_#{Atom.to_string(name)}" |> String.to_atom()
  end
end
