defmodule Chattr.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :sent_time, :content, :chat_id, :user_id, :inserted_at, :updated_at]}
  
  schema "messages" do
    field :sent_time, :utc_datetime
    field :content, :string
    belongs_to :chat, Chattr.Chats.Chat
    belongs_to :user, Chattr.Accounts.Users

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:sent_time, :content])
    |> validate_required([:sent_time, :content])
  end
end
