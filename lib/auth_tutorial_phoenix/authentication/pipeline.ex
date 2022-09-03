defmodule AuthTutorialPhoenix.Authentication.Pipeline do
  @claims %{typ: "access"}

  use Guardian.Plug.Pipeline,
  otp_app: :auth_tutorial_phoenix,
  module: AuthTutorialPhoenix.Authentication.Guardian,
  error_handler: AuthTutorialPhoenix.Authentication.ErrorHandler

plug Guardian.Plug.VerifyHeader, claims: @claims, scheme: "Bearer"
plug Guardian.Plug.EnsureAuthenticated
plug Guardian.Plug.LoadResource, allow_blank: false
end
