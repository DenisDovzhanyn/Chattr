defmodule Chattr.Accounts.Users do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:username, :display_name, :id]}

  schema "users" do
    field :username, :string
    field :password, :string
    field :temp_password, :string, virtual: true
    field :display_name, :string

    many_to_many :chats, Chattr.Chats.Chat, join_through: "user_chats"

    @timestamps_opts [type: :utc_datetime, inserted_at: false, updated_at: false]
  end

  @doc false
  def changeset(users, attrs) do
    users
    |> cast(attrs, [:username, :display_name, :temp_password])
    |> validate_required([:username, :display_name, :temp_password])
    |> hash_password()
    |> unique_constraint(:username)
  end

  def changeset_for_display_name(users, attrs) do
    users
    |> cast(attrs, [:display_name])
    |> validate_required([:display_name])
  end

  defp hash_password(changeset) do
    password =
      changeset
      |> get_change(:temp_password)
      |> Pbkdf2.hash_pwd_salt()


    put_change(changeset, :password, password)
  end
end
