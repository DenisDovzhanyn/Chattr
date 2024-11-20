defmodule ChattrWeb.MessageController do
  use ChattrWeb, :controller

  alias ChattrWeb.AuthenticateJWT
  alias Chattr.Messages

  def create(conn, %{"message" => message_params}) do
    case Messages.create_message(message_params) do
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
