defmodule Chattr.Chats do
  @moduledoc """
  The Chats context.
  """

  import Ecto.Query, warn: false
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
        IO.puts('in userid / last x chats clause')
        Repo.all(from x in Chat,
          join: uc in UserChat, on: uc.chat_id == x.id,
          where: uc.user_id == ^user_id,
          order_by: [desc: x.last_msg_time],
          limit: ^String.to_integer(last_x_chats))

      %{"user_id" => user_id} ->
        IO.puts('in user id clause')
        Repo.all(from x in Chat,
          join: uc in UserChat, on: uc.chat_id == x.id,
          where: uc.user_id == ^user_id)
          
      _ ->
        IO.puts('no matches in get chat function')
        []
    end

  end

  @doc """
  Creates a chat.

  ## Examples

      iex> create_chat(%{field: value})
      {:ok, %Chat{}}

      iex> create_chat(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_chat(attrs \\ %{}) do
    %Chat{}
    |> Chat.changeset(attrs)
    |> Repo.insert()
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
