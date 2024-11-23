defmodule Chattr.UserChat do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:user_id, :chat_id]}
  @primary_key {:user_id, :integer, autogenerate: false}
  @timestamps_opts [type: :utc_datetime, inserted_at: false, updated_at: false]

  schema "user_chats" do

    field :chat_id, :integer

  end

  @doc false
  def changeset(user_chat, attrs) do
    user_chat
    |> cast(attrs, [:user_id, :chat_id])
    |> validate_required([])
    |> unique_constraint(:name)
  end
end
