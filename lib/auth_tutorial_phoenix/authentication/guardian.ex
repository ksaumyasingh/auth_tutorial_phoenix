defmodule AuthTutorialPhoenix.Authentication.Guardian do
  use Guardian, otp_app: :auth_tutorial_phoenix
  alias AuthTutorialPhoenix.Accounts

  def subject_for_token(resource, _claims), do: {:ok, to_string(resource.id)}
  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = Accounts.get_user!(id)
    {:ok, resource} #or {:error, reason}
  end
end
