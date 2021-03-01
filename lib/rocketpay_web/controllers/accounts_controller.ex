defmodule RocketpayWeb.AccountsController do
  use RocketpayWeb, :controller

  alias Rocketpay.Account
  alias Rocketpay.Accounts.Transactions.Response, as: TransactionResponse
  alias Rocketpay.UserManager.Guardian

  action_fallback RocketpayWeb.FallbackController

  def deposit(conn, params) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, %Account{} = account} <- Rocketpay.deposit(params, user) do
      conn
      |> put_status(:ok)
      |> render("update.json", account: account)
    end
  end

  def withdraw(conn, params) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, %Account{} = account} <- Rocketpay.withdraw(params, user) do
      conn
      |> put_status(:ok)
      |> render("update.json", account: account)
    end
  end

  def transaction(conn, params) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, %TransactionResponse{} = transaction} <- Rocketpay.transaction(params, user) do
      conn
      |> put_status(:ok)
      |> render("transaction.json", transaction: transaction)
    end
  end
end
