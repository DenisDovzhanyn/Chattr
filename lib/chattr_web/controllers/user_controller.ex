defmodule ChattrWeb.UserController do
  use ChattrWeb, :controller

  alias Chattr.Accounts.Users
  alias Chattr.Accounts



  def create(conn , %{"username" => username, "password" => password, "display_name" => display_name}) do
    case Accounts.create_users(%{username: username, temp_password: password, display_name: display_name}) do
      {:ok, {%Users{id: id}, keys}} ->

        conn
        |> put_status(:created)
        |> json(%{keys: keys})

      {:error, changeset} ->

        errs = changeset.errors
        |> Enum.map(&EncodeError.encode/1)

        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: errs})
    end
  end

  def update_display_name(conn, _params) do
    user = Accounts.update_users_display_name(conn.params)
    json(conn, %{user: user})
  end

  def login(conn, %{"username" => username, "password" => password, "keepLoggedIn" => keepLoggedIn}) do

    case Accounts.login_users(%{"username" => username, "password" => password}) do
      {:ok, _, id} ->
        login_helper(conn, id, keepLoggedIn)

      {:error, text} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: text})
    end
  end

  def login_one_time_key(conn, %{"username" => username, "key" => key, "keepLoggedIn" => keepLoggedIn}) do


    case Accounts.login_one_time_key(%{"username" => username, "key" => key}) do
      {:ok, id} ->
        login_helper(conn, id, keepLoggedIn)

      {:error, text} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: text})
    end
  end


  defp login_helper(conn, id, keepLoggedIn) do
    fifteen_minutes = 900
    one_week = 604800
    access_token = Auth.generate_and_sign!(%{"user_id" => id,
      "exp" => Joken.current_time() + fifteen_minutes,
      "token_type" => "access"})

    refresh_token = Auth.generate_and_sign!(%{"user_id" => id,
      "exp" => Joken.current_time() + one_week,
      "token_type" => "refresh"})

    Redix.command(:redix, ["SET", "refresh_token:#{id}", refresh_token, "EX", "604800"])
    if keepLoggedIn do
      conn
      |> put_resp_cookie("refresh_token", refresh_token, http_only: true, secure: true, same_site: "strict", max_age: one_week)
      |> put_status(:ok)
      |> json(%{"access_token" => access_token})
    else
      conn
      |> put_resp_cookie("refresh_token", refresh_token, http_only: true, secure: true, same_site: "strict")
      |> put_status(:ok)
      |> json(%{"access_token" => access_token})
    end
  end


end
