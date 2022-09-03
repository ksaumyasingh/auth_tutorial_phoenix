defmodule AuthTutorialPhoenixWeb.UserController do
  use AuthTutorialPhoenixWeb, :controller

  alias AuthTutorialPhoenix.Accounts
  alias AuthTutorialPhoenix.Accounts.User

  action_fallback AuthTutorialPhoenixWeb.FallbackController

  def register(conn, user_params) do
    with {:ok,user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> text("regi. successfull")
    end
  end
end
