defmodule ChattrWeb.AuthenticateJWT do
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]
  def init(opt), do: opt

  def call(conn, _opts) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        case verify_token(token) do
          {:ok, claims} -> assign(conn, :claims, claims)

          _ -> unauthorized(conn)

        end
      _ -> unauthorized(conn)
    end
  end

  defp verify_token(token) do
    IO.puts(token)
    Auth.verify_and_validate(token)
  end

  defp unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> json(%{error: "Unauthorized"})
    |> halt()
  end

  def not_authorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> json(%{error: "Unauthorized"})
  end
end
