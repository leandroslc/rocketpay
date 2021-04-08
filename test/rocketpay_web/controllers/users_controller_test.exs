defmodule RocketpayWeb.UsersControllerTest do
  use RocketpayWeb.ConnCase, async: true

  describe "create/2" do
    test "should create user", %{conn: conn} do
      params = %{
        "name" => "Test User",
        "age" => "20",
        "email" => "test-user@example.com",
        "password" => "Pass$123",
        "nickname" => "test-user"
      }

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:created)

      assert %{
        "message" => "User created",
        "user" => %{
          "id" => _id,
          "name" => "Test User",
          "nickname" => "test-user",
          "account" => %{
            "id" => _account_id,
            "balance" => "0.0"
          }
        }
      } = response
    end
  end
end
