defmodule ChattrWeb.RefreshController do
  alias ChattrWeb.AuthenticateJWT
  use ChattrWeb, :controller


  def refresh_access_token(%{cookies: %{"refresh_token" => refresh_token}} = conn, _) do
    case Auth.verify_and_validate(refresh_token) do
      {:ok, %{"token_type" => "refresh"} = claims} ->
        case Redix.command(:redix, ["GET", "refresh_token:#{claims["user_id"]}"]) do
          {:ok, token} ->
            if token == refresh_token do
              new_token =
                Auth.generate_and_sign!(
                %{"user_id" => claims["user_id"],
                 "exp" => Joken.current_time() + 900,
                 "token_type" => "access"})


              ## check to see whether its ab to expire, if it is we refresh the refresh!
              conn = if is_number(claims["exp"]) && claims["exp"] - Joken.current_time() < 86400 do
                refresh_token = Auth.generate_and_sign!(%{"user_id" => claims["user_id"],
                  "exp" => Joken.current_time() + 604800,
                  "token_type" => "refresh"})
      
                Redix.command(:redix, ["SET", "refresh_token:#{claims["user_id"]}", refresh_token, "EX", "604800"])
                put_resp_cookie(conn,"refresh_token", refresh_token, http_only: true, secure: true, same_site: "strict", max_age: 604800 )
              else
                conn
              end

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


  def refresh_access_token(conn, _), do: AuthenticateJWT.not_authorized(conn)

end
