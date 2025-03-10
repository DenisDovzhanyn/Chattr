defmodule Chattr.Accounts.Users do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:display_name, :id]}

  schema "users" do
    field :username, :string
    field :password, :string
    field :temp_password, :string, virtual: true
    field :display_name, :string
    field :find_random_chat, :boolean

    many_to_many :chats, Chattr.Chats.Chat, join_through: "user_chats", join_keys: [user_id: :id, chat_id: :id]

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

  def changeset_for_random_chat(user, attrs) do
    user
    |> cast(attrs, [:find_random_chat])
  end

  def changeset_for_password(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> hash_password()
  end

  defp hash_password(changeset) do
    password =
      changeset
      |> get_change(:temp_password)
      |> Pbkdf2.hash_pwd_salt()


    put_change(changeset, :password, password)
  end
end
