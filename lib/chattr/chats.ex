defmodule Chattr.Chats do
  @moduledoc """
  The Chats context.
  """

  import Ecto.Query, warn: false
  alias ChattrWeb.AuthenticateJWT
  alias Chattr.Repo

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

        Repo.all(from uc in UserChat,
          join: c in Chat, on: c.chat_id == uc.id,
          where: uc.user_id == ^user_id)

      _ ->

        []
    end

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
  def create_chat(user_id) do

    {_atom, chat} = %Chat{}
      |> Chat.changeset(%{})
      |> Repo.insert()

    %UserChat{}
    |> UserChat.changeset(%{user_id: user_id, chat_id: chat.id})
    |> Repo.insert()
  end

   ## REMEMBER TO TEST THJIS BRO PLEASE I HAVENT TESTED PLEASE REMEMBER TO TEST THIS TEST TEST
   ## TEST TEST TEST ETEST TEST TEST TES TEST TEST TEST TEST TEST TEST ETS TEST
  def add_user(%{"user_id" => user_id, "chat_id" => chat_id}, inviter_id) do
    case get_chat_by_user_and_chat_id(%{"user_id" => inviter_id, "chat_id" => chat_id}) do
      %UserChat{} ->
        %UserChat{}
          |> UserChat.changeset(%{user_id: user_id, chat_id: chat_id})
          |> Repo.insert()

      nil -> nil
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
