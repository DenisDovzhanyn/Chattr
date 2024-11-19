defmodule Chattr.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  alias Expo.Message
  alias Chattr.Repo

  alias Chattr.Messages.Message

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages do
    Repo.all(Message)
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message_by(type_of_id) do
    IO.puts('im in here')
    IO.inspect(type_of_id)
    case type_of_id do
      %{"id" => id} ->
        IO.puts('now im in the id case #{id}')
        Repo.all(from x in Message, where: x.id == ^id)

      %{"chat_id" => chat_id, "last_x_messages" => last_x_messages} ->
        IO.puts('now in chat id / last x msgs clause')
        Repo.all(
          from x in Message,
          where: x.chat_id == ^chat_id,
          order_by: [desc: x.sent_time],
          limit: ^String.to_integer(last_x_messages)
        )

      %{"chat_id" => chat_id} ->
        IO.puts('now in chat id clause #{chat_id}')
        Repo.all(from x in Message, where: x.chat_id == ^chat_id)


      %{"user_id" => user_id} ->
        IO.puts('now in user id clause #{user_id}')
        Repo.all(from x in Message, where: x.user_id == ^user_id)

      _ ->
        IO.puts('looks like its not matching anything')
        []
    end
  end





  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end
end