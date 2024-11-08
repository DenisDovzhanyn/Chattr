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

  def show(conn, _params) do
    message = Messages.get_message_by(conn.params)
    json(conn, message)
  end
end
