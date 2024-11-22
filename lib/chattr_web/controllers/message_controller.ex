defmodule ChattrWeb.MessageController do
  use ChattrWeb, :controller

  alias ChattrWeb.AuthenticateJWT
  alias Chattr.Messages

  def create(conn, %{"content" => _content, "chat_id" => _chat_id} = msg_params) do
    msg_params = Map.put(msg_params, "user_id", conn.assigns[:claims]["user_id"])
    case Messages.create_message(msg_params) do
      {:ok, message} ->
        conn
        |> put_status(:created)
        |> json(message)

      {:error, changeset} ->
        errs = changeset.errors
        |> Enum.map(&EncodeError.encode/1)

        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: errs})

      {:unauthorized} ->
        conn
        |> AuthenticateJWT.not_authorized()
    end
  end

  def show(conn, _params) do
    case Messages.get_message_by(conn.params, conn.assigns[:claims]["user_id"]) do
      {:ok, messages} ->
        conn
        |> put_status(:ok)
        |> json(messages)

      _ ->
        AuthenticateJWT.not_authorized(conn)
    end

  end
end

### NEXT STEPS!
# 1. ADD SSH/ MAKE IT SO THAT WHEN SOMEONE USES AN SSH THEY MUST CHANGE PASSWORD
# 2. LET THEM CHANGE PASSWORD WITHOUT SSH BUT THEY MUST ENTER THE CORRECT PASSWORD TO CHANGE
# 3. I DONT KNOW LOL
