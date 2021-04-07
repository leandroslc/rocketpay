defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.{Account, User}
  alias RocketpayWeb.TestHelper

  describe "deposit/2" do
    setup %{conn: conn} do
      params = %{
        name: "Test User",
        age: 20,
        email: "test-user@example.com",
        password: "Pass$123",
        nickname: "test-user"
      }

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

      {:ok, token} = TestHelper.authenticate(params)

      conn = conn
        |> put_req_header("authorization", "Bearer " <> token)

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
end
