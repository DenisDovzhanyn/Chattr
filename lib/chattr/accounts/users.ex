defmodule Chattr.Accounts.Users do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :password, :string
    field :display_name, :string
    many_to_many :chats, Chattr.Chats.Chat, join_through: "user_chats"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(users, attrs) do
    users
    |> cast(attrs, [:username, :display_name, :password])
    |> validate_required([:username, :display_name, :password])
    |> unique_constraint(:password)
    |> unique_constraint(:username)
  end
end
