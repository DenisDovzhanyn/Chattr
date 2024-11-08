defmodule ChattrWeb.MessageController do
  use ChattrWeb, :controller

  alias Chattr.Messages

  def create(conn, %{"message" => message_params}) do
    case Messages.create_message(message_params) do
      {:ok, message} ->
        conn
        |> put_status(:created)
        |>json(message)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |>json(%{errors: changeset.errors})
    end
  end

  def show(conn, %{"chat_id" => chat_id}) do
    message = Messages.get_message_by(%{chat_id: chat_id})
    json(conn, message)
  end

  def show(conn, %{"user_id" => user_id}) do
    message = Messages.get_message_by(%{user_id: user_id})
    json(conn, message)
  end

  def show(conn, %{"id" => id}) do
    message = Messages.get_message_by(%{id: id})
    json(conn, message)
  end
end
