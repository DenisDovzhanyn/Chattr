defmodule ChattrWeb.RefreshController do
  alias ChattrWeb.AuthenticateJWT
  use ChattrWeb, :controller



  def refresh_access_token(conn, %{"refresh_token" => refresh_token}) do
    case Auth.verify_and_validate(refresh_token) do
      {:ok, %{"token_type" => "refresh"} = claims} ->
        case Redix.command(:redix, ["GET", "refresh_token:#{claims["user_id"]}"]) do
          {:ok, token} ->
            if token == refresh_token do
              new_token =
                Auth.generate_and_sign(
                %{"user_id" => claims["user_id"],
                 "exp" => Joken.current_time() + 900,
                 "token_type" => "access"})

              conn
              |> put_status(:ok)
              |> json(%{"access_token" => new_token})
            else
              AuthenticateJWT.not_authorized(conn)
            end

          _ -> AuthenticateJWT.not_authorized(conn)
        end

      _ -> AuthenticateJWT.not_authorized(conn)
    end

  end
end
