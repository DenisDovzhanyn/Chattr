defmodule ChattrWeb.ChatChannel do
  alias ChattrWeb.OfflineKeyQueue
  alias ChattrWeb.ConnectedUsers
  alias Chattr.Messages.Message
  alias Chattr.Messages
  alias Chattr.UserChat
  alias Chattr.Chats
  use Phoenix.Channel

  def join("chat:" <> chat_id, _params, socket) do
    case Chats.get_chat_by_user_and_chat_id(%{"user_id" => socket.assigns["user_id"], "chat_id" => chat_id}) do
      %UserChat{} ->
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

  # maybe instead of storing a list of users and chats they are connected to, we just store a ets table of users that are online?

  def handle_in("send_key", %{"key" => key, "user_id" => recipient}, socket) do
    case ConnectedUsers.get_users(recipient) do
      [[socket]] ->
        push(socket, "new_key", %{"chat_id" => socket.assigns["chat_id"], "key" => key})

      [] ->
        OfflineKeyQueue.add_key(recipient, key)
    end
  end

  # this is an initial call that the client will make to fetch all keys waiting if any
  def handle_in("fetch_keys", _payload, socket) do
    keys = OfflineKeyQueue.get_keys(socket.assigns["user_id"])

    if Kernel.length(keys) >= 1 do
      push(socket, "new_key", %{"keys" => keys})
      OfflineKeyQueue.remove_keys(socket.assigns["user_id"])
    end

    {:noreply, socket}
  end
end
