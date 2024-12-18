defmodule ChattrWeb.ChatController do
  use ChattrWeb, :controller

  alias ChattrWeb.AuthenticateJWT
  alias Chattr.Chats
  alias Chattr.Accounts

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

  def leave_chat(conn, %{"chat_id" => chat_id}) do
    user_id = conn.assigns[:claims]["user_id"]
    case Chats.remove_user(%{"user_id" => user_id, "chat_id" => chat_id}) do
      {:ok, _chat} ->
        conn
        |> put_status(:ok)
        |> json("Removed")

      nil ->
        conn
        |> AuthenticateJWT.not_authorized()
    end

  end

  def set_find_random_chat(conn, %{"is_finding_random_chat" => is_looking}) do
    user_id = conn.assigns[:claims]["user_id"]
    if is_looking do
      case Accounts.get_one_user_random_chat() do
        {:error, :no_available_users} ->

          Accounts.set_random_chat(%{"is_finding_random_chat" => is_looking, "user_id" => user_id})

          conn
          |> put_status(:ok)
          |> json("Currently no available users, will continue looking")

        {:ok, id} ->
          chat = Chats.create_chat(user_id)
          Chats.add_user(%{"user_id" => id, "chat_id" => chat[:id]}, user_id)

          conn
          |> put_status(:ok)
          |> json(chat)
      end
    else
      Accounts.set_random_chat(%{"is_finding_random_chat" => is_looking, "user_id" => user_id})

      conn
      |> put_status(:ok)
      |> json("Set to not looking")
    end


  end

  # I AM LEAVING YOU HERE,
    # FIRST YOU NEED TO COMPLETE THE LEAVE CHAT FUNCTION AND ITS INNER FUNCTIONS ASWELL
    # LIKE THE ACTUAL CHATS MODULE WHICH INTERACT WITH DB
    # WHEN A USER LEAVES WE NEED TO CHECK HOW MANY ENTRIES COME BACK FROM THE USER_CHATS TABLE
    # IF NO ENTRIES COME BACK THAT MEANS THAT THE CHAT IS EMPTY AND NO ONE IS IN IT
    # THIS MEANS WE CAN FREE UP SPACE SO WE NEED TO DELETE THE CHAT
    # AND ALL MESSAGES CONNECTED TO THE CHAT

    # AFTER THAT WE NEED TO ADD ENCRYPTING TO MESSAGES
    # ALSO YOU WILL NEED TO STORE A KEY WITH THE CHAT THAT USERS WILL RECEIVE TO BE ABLE TO DECODE MESSAGES
    # ACTUALLY I LIED WE WILL NOT BE ENCRYPTING ANY MESSAGES
    # THE CLIENT WILL BE ENCRYPTING / DECRYPTING MESSAGES

  def show(conn, _params) do
    chat = Chats.get_chat_by_user_id(%{"user_id" => conn.assigns[:claims]["user_id"]})
    json(conn, chat)
  end
end
