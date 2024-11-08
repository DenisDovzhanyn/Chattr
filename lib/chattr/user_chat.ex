defmodule Chattr.UserChat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_chats" do

    field :user_id, :id
    field :chat_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_chat, attrs) do
    user_chat
    |> cast(attrs, [])
    |> validate_required([])
  end
end
