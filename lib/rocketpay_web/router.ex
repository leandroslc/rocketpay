defmodule RocketpayWeb.Router do
  use RocketpayWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Rocketpay.UserManager.Pipeline
  end

  scope "/api", RocketpayWeb do
    pipe_through :api

    post "/signin", SessionController, :sign_in
    post "/users", UsersController, :create
  end

  scope "/api", RocketpayWeb do
    pipe_through [:api, :auth]

    put "/accounts/:id/deposit", AccountsController, :deposit
    put "/accounts/:id/withdraw", AccountsController, :withdraw
    post "/accounts/transaction", AccountsController, :transaction
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: RocketpayWeb.Telemetry
    end
  end
end
