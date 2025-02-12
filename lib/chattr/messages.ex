defmodule Chattr.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  alias Chattr.UserChat
  alias Chattr.Chats
  alias Expo.Message
  alias Chattr.Repo

  alias Chattr.Messages.Message

  def get_message_by(type_of_id, id) do
    case type_of_id do

      %{"chat_id" => chat_id, "last_x_messages" => last_x_messages} ->

        case Chats.get_chat_by_user_and_chat_id(%{"user_id" => id, "chat_id" => chat_id}) do

         %UserChat{} ->
            messages = Repo.all(
            from x in Message,
            where: x.chat_id == ^chat_id,
            order_by: [desc: x.inserted_at],
            limit: ^String.to_integer(last_x_messages)
            )
            {:ok, messages}

          nil -> {:unauthorized}
       end

      %{"chat_id" => chat_id, "since_message_id" => since_message_id} ->
        case Chats.get_chat_by_user_and_chat_id(%{"user_id" => id, "chat_id" => chat_id}) do
          %UserChat{} ->
            messages = Repo.all(
              from x in Message,
              where: x.chat_id == ^chat_id and x.id >= ^since_message_id,
              order_by: [desc: x.inserted_at])
            {:ok, messages}

          nil -> {:unauthorized}
        end

      %{"chat_id" => chat_id} ->
        case Chats.get_chat_by_user_and_chat_id(%{"user_id" => id, "chat_id" => chat_id}) do
          %UserChat{} ->
            messages = Repo.all(
              from x in Message,
              where: x.chat_id == ^chat_id,
              order_by: [desc: x.inserted_at]
            )
            {:ok, messages}

          nil -> {:unauthorized}
        end

      _ ->
        []
    end
  end




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
