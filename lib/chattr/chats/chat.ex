defmodule Chattr.Chats.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :last_msg_time, :users]}
  schema "chats" do
    field :last_msg_time, :utc_datetime
    many_to_many :users, Chattr.Accounts.Users, join_through: "user_chats", join_keys: [chat_id: :id, user_id: :id]

    @timestamps_opts [type: :utc_datetime, inserted_at: false, updated_at: false]
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:last_msg_time])
  end
end
