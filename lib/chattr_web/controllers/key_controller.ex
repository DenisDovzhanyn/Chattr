defmodule ChattrWeb.KeyController do
  use ChattrWeb, :controller


  alias Chattr.UserChat
  alias Chattr.Chats
  alias ChattrWeb.AuthenticateJWT

    def put_key(conn, %{"recipient" => recipient, "key" => key, "chat_id" => chat_id}) do
      case Chats.get_chat_by_user_and_chat_id(%{"user_id" => recipient, "chat_id" => chat_id}) do
        %UserChat{} ->
          case Redix.command(:redix, ["SET", "#{chat_id}:#{recipient}", key, "EX", "604800"]) do
            {:ok, _} ->
              conn
              |> put_status(:ok)
              |> json("success")
            {:error, _} ->
              conn
              |> put_status(:unprocessable_entity)
              |> json("error")
          end
        nil ->
          conn
          |> AuthenticateJWT.not_authorized()
      end
    end

    def get_key(conn, %{"chat_id" => chat_id}) do
      user_id = conn.assigns[:claims]["user_id"]

      case Redix.command(:redix, ["GET", "#{chat_id}:#{user_id}"]) do
        {:ok, key} ->
          conn
          |> put_status(:ok)
          |> json(key)

        {:error, _} ->
          conn
          |> put_status(:not_found)
          |> json("not found")
      end
    end
end
