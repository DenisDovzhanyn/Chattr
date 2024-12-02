defmodule ChattrWeb.UserSocket do
  alias ChattrWeb.ConnectedUsers
  alias ChattrWeb.AuthenticateJWT
  use Phoenix.Socket

  channel "chat:*", ChattrWeb.ChatChannel

  @impl true
  def connect(%{"token" => token}, socket, _connect_info) do
    case AuthenticateJWT.verify_token(token) do
      {:ok, %{"user_id" => user_id}} ->
        ConnectedUsers.add_user(user_id, socket)
       
        {:ok, assign(socket, "user_id", user_id)}

      {:error, reason} ->
        reason
    end
  end




  # Socket IDs are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     Elixir.ChattrWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  @impl true
  def id(_socket), do: nil
end
