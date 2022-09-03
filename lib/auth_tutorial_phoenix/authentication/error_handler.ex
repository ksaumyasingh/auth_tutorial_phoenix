defmodule AuthTutorialPhoenix.Authentication.ErrorHandler do
  import Plug.Conn
  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, "")
  end
end
