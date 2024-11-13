defmodule Chattr.MessagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Chattr.Messages` context.
  """

  @doc """
  Generate a message.
  """
  

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        content: "some content",
        sent_time: ~U[2024-11-07 03:00:00Z]
      })
      |> Chattr.Messages.create_message()

    message
  end
end
