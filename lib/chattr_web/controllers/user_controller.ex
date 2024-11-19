defmodule ChattrWeb.UserController do
  use ChattrWeb, :controller

  alias Chattr.Accounts.Users
  alias Chattr.Accounts

  def create(conn , %{"username" => username, "password" => password, "display_name" => display_name}) do
    case Accounts.create_users(%{username: username, temp_password: password, display_name: display_name}) do
      {:ok, %Users{id: id}} ->
        jwt_token = Auth.generate_and_sign!(%{"id" => id})
        conn
        |> put_status(:created)
        |> json(jwt_token)

      {:error, changeset} ->

        errs = changeset.errors
        |> Enum.map(&EncodeError.encode/1)
        IO.inspect(errs)
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: errs})
    end
  end

  def update_display_name(conn, _params) do
    user = Accounts.update_users_display_name(conn.params)
    json(conn, user)
  end

  def login(conn, %{"username" => username, "password" => password} = info) do
    case Accounts.login_users(info) do
      {:ok, _, id} ->
        jwt_token = Auth.generate_and_sign!(%{"id" => id})
        conn
        |> put_status(:ok)
        |> json(jwt_token)

      {:error, text} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(text)
    end
  end
end