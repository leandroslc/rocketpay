defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.{Account, User}
  alias RocketpayWeb.TestHelper

  describe "deposit/2" do
    setup %{conn: conn} do
      {:ok, %{account_id: account_id, params: params}} = create_user("Test User", "test-user")

      conn = conn |> authenticate(params)

      {:ok, conn: conn, account_id: account_id}
    end

    test "make deposit", %{conn: conn, account_id: account_id} do
      params = %{"value" => "50.0"}

      response =
        conn
        |> put(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:ok)

      assert %{
        "account" => %{"balance" => "50.0", "id" => _id},
        "message" => "Balance updated"
      } = response
    end

    test "returns an error when there are invalid params", %{conn: conn, account_id: account_id} do
      params = %{"value" => "abc"}

      response =
        conn
        |> put(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:bad_request)

        assert %{"errors" => %{"message" => "Invalid deposit value"}} = response
    end
  end

  describe "withdraw/2" do
    setup %{conn: conn} do
      {:ok, %{user: user, account_id: account_id, params: params}} = create_user("Test User", "test-user")

      conn = conn |> authenticate(params)

      {:ok, conn: conn, user: user, account_id: account_id}
    end

    test "make withdraw", %{conn: conn, user: user, account_id: account_id} do
      Rocketpay.deposit(%{"id" => account_id, "value" => "50.0"}, user)

      params = %{"value" => "50.0"}

      response =
        conn
        |> put(Routes.accounts_path(conn, :withdraw, account_id, params))
        |> json_response(:ok)

      assert %{
        "account" => %{"balance" => "0.0", "id" => _id},
        "message" => "Balance updated"
      } = response
    end

    test "returns an error if the withdraw value is greather than the account amount", %{conn: conn, user: user, account_id: account_id} do
      Rocketpay.deposit(%{"id" => account_id, "value" => "30.0"}, user)

      params = %{"value" => "50.0"}

      response =
        conn
        |> put(Routes.accounts_path(conn, :withdraw, account_id, params))
        |> json_response(:bad_request)

      assert %{"errors" => %{"message" => %{"balance" => ["is invalid"]}}} = response
    end

    test "returns an error when there are invalid params", %{conn: conn, account_id: account_id} do
      params = %{"value" => "abc"}

      response =
        conn
        |> put(Routes.accounts_path(conn, :withdraw, account_id, params))
        |> json_response(:bad_request)

      assert %{"errors" => %{"message" => "Invalid withdraw value"}} = response
    end
  end

  defp create_user(name, nickname) do
    {:ok, %User{account: %Account{id: account_id}} = user, params} = TestHelper.create_user(name, nickname)

    {:ok, %{user: user, account_id: account_id, params: params}}
  end

  defp authenticate(conn, params) do
    {:ok, token} = TestHelper.authenticate(params)

    conn |> put_req_header("authorization", "Bearer " <> token)
  end
end
