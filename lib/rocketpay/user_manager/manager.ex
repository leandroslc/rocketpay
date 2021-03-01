defmodule Rocketpay.UserManager.Manager do
  alias Bcrypt
  alias Rocketpay.{Repo, User}

  import Ecto.Query, only: [from: 2]

  def authenticate(email, plain_password) do
    query = from user in User, where: user.email == ^email

    case Repo.one(query) do
      nil -> handle_no_user()
      user -> verify_password(plain_password, user)
    end
  end

  defp verify_password(plain_password, %User{password_hash: password_hash} = user) do
    if Bcrypt.verify_pass(plain_password, password_hash) do
      {:ok, user}
    else
      handle_invalid_credentials()
    end
  end

  defp handle_no_user() do
    # Ensures it takes the same time as if the user existed
    Bcrypt.no_user_verify()

    handle_invalid_credentials()
  end

  defp handle_invalid_credentials(), do: {:error, :invalid_credentials}
end
