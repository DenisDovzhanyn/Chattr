defmodule ChattrWeb.ChatController do
  use ChattrWeb, :controller

  alias Chattr.Chats

  def create(conn, %{"chat" => chat_params}) do
    case Chats.create_chat(chat_params) do
      {:ok, chat} ->
        conn
        |> put_status(:created)
        |> json(chat)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset.errors})
    end
  end

  def show(conn, _params) do
    chat = Chats.get_chat_by_user_id(conn.params)
    json(conn, chat)
  end
end
