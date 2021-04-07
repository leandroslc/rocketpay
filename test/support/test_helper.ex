defmodule RocketpayWeb.TestHelper do
  alias Rocketpay.UserManager.Manager, as: UserManager
  alias Rocketpay.UserManager.Guardian

  def create_user(name, nickname) do
    params = %{
      name: name,
      age: 20,
      email: "#{nickname}@example.com",
      password: "Pass$123",
      nickname: nickname
    }

    {:ok, user} = Rocketpay.create_user(params)

    {:ok, user, %{email: params.email, password: params.password}}
  end

  def authenticate(%{email: email, password: password}) do
    UserManager.authenticate(email, password)
    |> handle_sign_in()
  end

  defp handle_sign_in({:ok, user}) do
    with {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      {:ok, token}
    end
  end

end
