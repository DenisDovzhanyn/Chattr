defmodule ChattrWeb.AuthenticateJWT do
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]
  def init(opt), do: opt

  def call(conn, _opts) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        case verify_token(token) do
          {:ok, %{"token_type" => "access"} = claims} -> assign(conn, :claims, claims)

          _ -> unauthorized(conn)

        end
      _ -> unauthorized(conn)
    end
  end

  def verify_token(token) do
    Auth.verify_and_validate(token)
  end

  defp unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> json(%{error: "Unauthorized"})
    |> halt()
  end

  def forbidden(conn) do
    conn
    |> put_status(:forbidden)
    |> json(%{error: "Forbidden"})
  end

  def not_authorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> json(%{error: "Unauthorized"})
  end
end
