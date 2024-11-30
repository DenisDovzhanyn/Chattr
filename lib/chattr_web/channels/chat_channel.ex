defmodule ChattrWeb.ChatChannel do
  alias ChattrWeb.ConnectedUsers
  alias Chattr.Messages.Message
  alias Chattr.Messages
  alias Chattr.UserChat
  alias Chattr.Chats
  use Phoenix.Channel

  def join("chat:" <> chat_id, _params, socket) do
    case Chats.get_chat_by_user_and_chat_id(%{"user_id" => socket.assigns["user_id"], "chat_id" => chat_id}) do
      %UserChat{} ->
        ConnectedUsers.add_user(chat_id, socket.assigns["user_id"], socket)
        IO.inspect(ConnectedUsers.get_users(chat_id))
        {:ok, assign(socket, "chat_id", chat_id)}
      _ -> {:error, %{"reason" => "unauthorized"}}
    end
  end

  def handle_in("new_msg", %{"content" => content}, socket) do
    case Messages.create_message(%{"user_id" => socket.assigns["user_id"], "chat_id" => socket.assigns["chat_id"], "content" => content}) do
      {:ok, %Message{}} ->
        broadcast!(socket, "new_msg", %{"content" => content})
        {:noreply, socket}

      {:unauthorized} ->
        push(socket, "error", %{"reason" => "unauthorized"})
        {:noreply, socket}

      _ ->
        push(socket, "error", %{"reason" => "unknown_error"})
        {:noreply, socket}

    end
  end

  #def handle_in("new_msg", %{"key" => key}, socket) do

  #end

  def terminate(reason, socket) do
    chat_id = socket.assigns["chat_id"]
    user_id = socket.assigns["user_id"]
    ConnectedUsers.remove_user(chat_id, user_id)
    {:ok, socket}
  end
end
