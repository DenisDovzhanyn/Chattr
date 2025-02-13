defmodule ChattrWeb.MessageController do
  use ChattrWeb, :controller

  alias ChattrWeb.AuthenticateJWT
  alias Chattr.Messages

  def show(conn, _params) do
    case Messages.get_message_by(conn.params, conn.assigns[:claims]["user_id"]) do
      {:ok, messages} ->
        conn
        |> put_status(:ok)
        |> json(%{messages: messages, chat_id: conn.params["chat_id"]})

      _ ->
        AuthenticateJWT.forbidden(conn)
    end

  end
end

### NEXT STEPS!
# 1. ADD SSH/ MAKE IT SO THAT WHEN SOMEONE USES AN SSH THEY MUST CHANGE PASSWORD
# 2. LET THEM CHANGE PASSWORD WITHOUT SSH BUT THEY MUST ENTER THE CORRECT PASSWORD TO CHANGE
# 3. I DONT KNOW LOL
