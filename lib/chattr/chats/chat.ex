defmodule Chattr.Chats.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chats" do
    field :last_msg_time, :utc_datetime
    many_to_many :users, Chattr.Accounts.Users, join_through: "user_chats"
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:last_msg_time])
    |> validate_required([:last_msg_time])
  end
end
