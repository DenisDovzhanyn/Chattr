defmodule ChattrWeb.ChatController do
  use ChattrWeb, :controller

  alias ChattrWeb.AuthenticateJWT
  alias Chattr.Chats

  def create(conn, _) do
    user_id = conn.assigns[:claims]["user_id"]

    case Chats.create_chat(user_id) do
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

  def add_user(conn, _) do

    case Chats.add_user(conn.params, conn.assigns[:claims]["user_id"]) do
      {:ok, chat} ->
        conn
        |> put_status(:ok)
        |> json(chat)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset.errors})

      _ ->
        conn
        |> AuthenticateJWT.not_authorized()
    end
  end

  def show(conn, _params) do
    chat = Chats.get_chat_by_user_id(conn.params)
    json(conn, chat)
  end
end
