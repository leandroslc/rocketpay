defmodule Rocketpay.UserManager.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :rocketpay,
    error_handler: Rocketpay.UserManager.ErrorHandler,
    module: Rocketpay.UserManager.Guardian

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
