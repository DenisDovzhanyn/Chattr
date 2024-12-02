defmodule Chattr.ChatsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Chattr.Chats` context.
  """

  @doc """
  Generate a chat.
  """
  def chat_fixture(attrs \\ %{}) do
    {:ok, chat} =
      attrs
      |> Enum.into(%{
        last_msg_time: ~U[2024-11-07 02:36:00Z]
      })
      |> Chattr.Chats.create_chat()

    chat
  end
end
