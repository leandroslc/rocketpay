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

    test "should return error if not authorized", %{account_id: account_id} do
      conn = build_conn()

      conn
      |> put(Routes.accounts_path(conn, :deposit, account_id, %{}))
      |> json_response(:unauthorized)
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

    test "should return error if not authorized", %{account_id: account_id} do
      conn = build_conn()

      conn
      |> put(Routes.accounts_path(conn, :withdraw, account_id, %{}))
      |> json_response(:unauthorized)
    end
  end

  describe "transaction/2" do
    setup %{conn: conn} do
      {:ok, %{user: user, account_id: from_id, params: sender_params}} = create_user("Sender User", "sender-user")
      {:ok, %{account_id: to_id}} = create_user("Receiver User", "receiver-user")

      conn = conn |> authenticate(sender_params)

      {:ok, conn: conn, user: user, from_id: from_id, to_id: to_id}
    end

    test "make transaction", %{conn: conn, user: user, from_id: from_id, to_id: to_id} do
      Rocketpay.deposit(%{"id" => from_id, "value" => "100.0"}, user)

      params = %{"from" => from_id, "to" => to_id, "value" => "60.0"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :transaction, params))
        |> json_response(:ok)

      assert %{
        "message" => "Transaction done",
        "transaction" => %{
          "from_account" => %{
            "balance" => "40.0",
            "id" => _from_id
          },
          "to_account" => %{
            "balance" => "60.0",
            "id" => _to_id
          }
        }
      } = response
    end

    test "should return error if not authorized" do
      conn = build_conn()

      conn
      |> post(Routes.accounts_path(conn, :transaction, %{}))
      |> json_response(:unauthorized)
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
