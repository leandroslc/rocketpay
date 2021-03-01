defmodule Rocketpay.Users.Find do
  alias Rocketpay.Repo
  alias Rocketpay.User

  def call(id) do
    Repo.get(User, id)
  end
end
