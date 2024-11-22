defmodule Chattr.UserKey do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:key]}
  @primary_key {:user_id, :integer, autogenerate: false}
  @timestamps_opts [type: :utc_datetime, inserted_at: false, updated_at: false]

  schema "User_Keys" do
    field :key, :string
    field :used, :boolean
  end

  @doc false
  def changeset(user_chat, attrs) do
    user_chat
    |> cast(attrs, [:user_id, :key, :used])
    |> validate_required([])
  end
end
