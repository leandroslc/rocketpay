defmodule RocketpayWeb.SessionControllerTest do
  use RocketpayWeb.ConnCase, async: true

  describe "sign_in/2" do
    setup %{conn: conn} do
      user_params = %{
        name: "Test User",
        age: 20,
        email: "test-user@example.com",
        password: "Pass$123",
        nickname: "test-user"
      }

      Rocketpay.create_user(user_params)

      {:ok, conn: conn}
    end

    test "must sign in with valid credentials", %{conn: conn} do
      params = %{"email" => "test-user@example.com", "password" => "Pass$123"}

      response =
        conn
        |> post(Routes.session_path(conn, :sign_in, params))
        |> json_response(:ok)

      assert %{"token" => token} = response
      refute token == nil
    end

    test "returns error for invalid credentials", %{conn: conn} do
      params = %{"email" => "test-user@example.com", "password" => "123"}

      response =
        conn
        |> post(Routes.session_path(conn, :sign_in, params))
        |> json_response(:unauthorized)

      assert %{"errors" => %{"message" => "Invalid credentials"}} = response
    end

    test "returns error if user does not exist", %{conn: conn} do
      params = %{"email" => "test@example.com", "password" => "123"}

      response =
        conn
        |> post(Routes.session_path(conn, :sign_in, params))
        |> json_response(:unauthorized)

      assert %{"errors" => %{"message" => "Invalid credentials"}} = response
    end
  end
end
