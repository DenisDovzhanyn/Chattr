defmodule Chattr.Chats do
  @moduledoc """
  The Chats context.
  """

  import Ecto.Query, warn: false
  alias Chattr.Accounts.Users
  alias Chattr.Accounts
  alias ChattrWeb.AuthenticateJWT
  alias Chattr.Repo
  alias Chattr.Messages.Message
  alias Chattr.Chats.Chat
  alias Chattr.UserChat


  @doc """
  Returns the list of chats.

  ## Examples

      iex> list_chats()
      [%Chat{}, ...]

  """
  def list_chats do
    Repo.all(Chat)
  end

  @doc """
  Gets a single chat.

  Raises `Ecto.NoResultsError` if the Chat does not exist.

  ## Examples

      iex> get_chat!(123)
      %Chat{}

      iex> get_chat!(456)
      ** (Ecto.NoResultsError)

  """
  #def get_chat!(id), do: Repo.get!(Chat, id)

  def get_chat_by_user_id(query_params) do
    case query_params do

      %{"user_id" => user_id, "last_x_chats" => last_x_chats} ->

        Repo.all(from x in Chat,
          join: uc in UserChat, on: uc.chat_id == x.id,
          where: uc.user_id == ^user_id,
          order_by: [desc: x.last_msg_time],
          limit: ^String.to_integer(last_x_chats))

      %{"user_id" => user_id} ->
        # god i hate ecto so much
        Repo.all(
          from c in Chattr.Chats.Chat,
          join: uc in Chattr.UserChat, on: uc.chat_id == c.id,
          join: u in Chattr.Accounts.Users, on: uc.user_id == u.id,
          where: uc.user_id == ^user_id,
          order_by: [desc: c.last_msg_time],
          preload: [:users]
        )

      _ ->

        []
    end

  end

  def get_all_users_by_chat_id(chat_id) do
    Repo.all(from uc in UserChat,
      join: u in assoc(uc, :user),
      where: uc.chat_id == ^chat_id,
      select: %{user_id: u.id, display_name: u.display_name}
    )
  end

  def get_chat_by_user_and_chat_id(%{"user_id" => user_id, "chat_id" => chat_id}) do
    Repo.get_by(UserChat, user_id: user_id, chat_id: chat_id)
  end


  @doc """
  Creates a chat.

  ## Examples

      iex> create_chat(%{field: value})
      {:ok, %Chat{}}

      iex> create_chat(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_chat(%{"user_id" => user_id, "chat_name" => chat_name}) do

    {atom, chat} = %Chat{}
      |> Chat.changeset(%{last_msg_time: DateTime.utc_now() |> Calendar.strftime("%Y-%m-%d %H:%M:%S") ,chat_name: chat_name})
      |> Repo.insert()

    %UserChat{}
      |> UserChat.changeset(%{user_id: user_id, chat_id: chat.id})
      |> Repo.insert()

    chat = Repo.preload(chat, :users)
    {atom, chat}
  end


  def add_user(%{"username" => username, "chat_id" => chat_id}, inviter_id) do
    case get_chat_by_user_and_chat_id(%{"user_id" => inviter_id, "chat_id" => chat_id}) do
      %UserChat{} ->
        case Accounts.get_users_by_username(username) do
          %Users{id: user_id} ->

            if get_chat_by_user_and_chat_id(%{"user_id" => user_id, "chat_id" => chat_id}) == nil do
              {_, userchat} = %UserChat{}
                |> UserChat.changeset(%{user_id: user_id, chat_id: chat_id})
                |> Repo.insert()

              chat = Repo.get_by(Chat, id: userchat.chat_id)
              chat = Repo.preload(chat, :users)
              {:ok, chat}
            else 
              :conflict
            end
          nil -> :not_found
        end
      nil -> nil
    end

  end



  def remove_user (%{"user_id" => user_id, "chat_id" => chat_id}) do
    case get_chat_by_user_and_chat_id(%{"user_id" => user_id, "chat_id" => chat_id}) do

      %UserChat{} = user_chat ->
        response = Repo.delete(user_chat)
        users_in_chat = length(Repo.all(from chat in UserChat, where: chat.chat_id == ^chat_id))

        if users_in_chat > 0 do
          response
        else
          chat = Repo.get(Chat, chat_id)
          chat
          |> Repo.delete()

          Repo.delete_all(from message in Message, where: message.chat_id == ^chat_id)
          response
        end

      nil ->
        nil
    end
  end

  @doc """
  Updates a chat.

  ## Examples

      iex> update_chat(chat, %{field: new_value})
      {:ok, %Chat{}}

      iex> update_chat(chat, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_chat(%Chat{} = chat, attrs) do
    chat
    |> Chat.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a chat.

  ## Examples

      iex> delete_chat(chat)
      {:ok, %Chat{}}

      iex> delete_chat(chat)
      {:error, %Ecto.Changeset{}}

  """
  def delete_chat(%Chat{} = chat) do
    Repo.delete(chat)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking chat changes.

  ## Examples

      iex> change_chat(chat)
      %Ecto.Changeset{data: %Chat{}}

  """
  def change_chat(%Chat{} = chat, attrs \\ %{}) do
    Chat.changeset(chat, attrs)
  end
end
