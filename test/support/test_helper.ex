defmodule RocketpayWeb.TestHelper do
  alias Rocketpay.UserManager.Manager, as: UserManager
  alias Rocketpay.UserManager.Guardian

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
