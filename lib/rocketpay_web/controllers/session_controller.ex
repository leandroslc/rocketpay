defmodule RocketpayWeb.SessionController do
  use RocketpayWeb, :controller

  alias Rocketpay.UserManager.Manager, as: UserManager
  alias Rocketpay.UserManager.Guardian

  def sign_in(conn, %{"email" => email, "password" => password}) do
    UserManager.authenticate(email, password)
    |> handle_sign_in(conn)
  end

  defp handle_sign_in({:error, :invalid_credentials}, conn) do
    conn
    |> put_status(:unauthorized)
    |> put_view(RocketpayWeb.ErrorView)
    |> render("401.json", result: "Invalid credentials")
  end

  defp handle_sign_in({:ok, user}, conn) do
    with {:ok, jwt, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:ok)
      |> json(%{jwt: jwt})
    end
  end
end
