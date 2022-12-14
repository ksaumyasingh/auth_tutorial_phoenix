defmodule AuthTutorialPhoenixWeb.SessionController do
  use AuthTutorialPhoenixWeb, :controller
  alias AuthTutorialPhoenix.Accounts
  alias AuthTutorialPhoenix.Authentication.Guardian

  action_fallback AuthTutorialPhoenixWeb.FallbackController

  def new(conn, user_params) do
    case Accounts.create_user(user_params) do
    {:ok, user} ->
      IO.inspect(user)
      {:ok, access_token, _claims} =
        Guardian.encode_and_sign(user, %{}, token_type: "access", ttl: {15, :minute})
      IO.inspect(access_token)

      {:ok, refresh_token, _claims} =
        Guardian.encode_and_sign(user, %{}, token_type: "refresh", ttl: {7, :day})

      IO.inspect(refresh_token)
      conn
      |> put_resp_cookie("ruid", refresh_token)
      |> put_status(:created)
      |> render("token.json", %{access_token: access_token})
    {:error, :unauthorized} ->
      body = Jason.encode!(%{error: "unauthorized"})
      conn
      |> send_resp(401, body)
    end
  end

  def refresh(conn, _params) do
    refresh_token =
      Plug.Conn.fetch_cookies(conn) |> Map.from_struct() |> get_in([:cookies, "ruid"])

    case Guardian.exchange(refresh_token, "refresh", "access") do
      {:ok, _old_stuff, {new_access_token, _new_claims}} ->
        conn
        |> put_status(:created)
        |> render("token.json", %{access_token: new_access_token})

      {:error, _reason} ->
        body = Jason.encode!(%{error: "unauthorized"})
        conn
        |> send_resp(401, body)
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_resp_cookie("ruid")
    |> put_status(200)
    |> text("log out successful.")
  end
end
