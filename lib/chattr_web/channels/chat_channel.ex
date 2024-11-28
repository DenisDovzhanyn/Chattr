defmodule ChattrWeb.ChatChannel do
  alias Chattr.UserChat
  use Phoenix.Channel

  def join("chat:" <> chat_id, _params, socket) do
    case Chats.get_chat_by_user_and_chat_id(%{"user_id" => socket.assigns["user_id"], "chat_id" => chat_id}) do
      %UserChat{} ->
        {:ok, socket}

      _ -> {:error, %{"reason" => "unauthorized"}}
    end
  end
end
