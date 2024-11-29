defmodule ChattrWeb.ChatChannel do
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
      %Message{} ->
        broadcast!(socket, "new_msg", %{"content" => content})
        {:noreply, socket}
        
      _ -> {:error, %{"reason" => "unauthorized"}}
    end
  end
end
