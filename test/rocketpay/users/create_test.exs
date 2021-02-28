defmodule Rocketpay.Users.CreateTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.User
  alias Rocketpay.Users.Create

  describe "call/1" do
    test "returns an user when all params are valid" do
      params = %{
        name: "Test User",
        age: 20,
        email: "test-user@example.com",
        password: "Pass$123",
        nickname: "test-user"
      }

      {:ok, %User{id: user_id}} = Create.call(params)

      user = Repo.get(User, user_id)

      assert %{
        name: "Test User",
        age: 20,
        email: "test-user@example.com",
        nickname: "test-user",
        id: ^user_id
      } = user
    end

    test "returns an error when there are invalid params" do
      params = %{
        name: "Test User",
        age: 16,
        email: "example.com",
        password: "123",
        nickname: "test-user"
      }

      {:error, changeset} = Create.call(params)

      expected_errors = %{
        age: ["must be greater than or equal to 18"],
        email: ["has invalid format"],
        password: ["should be at least 6 character(s)"]
      }

      assert errors_on(changeset) == expected_errors
    end
  end
end
