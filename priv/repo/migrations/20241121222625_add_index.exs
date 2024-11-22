defmodule Chattr.Repo.Migrations.AddIndex do
  use Ecto.Migration

  def change do
    alter table(:User_Keys) do
      add :used, :boolean
      remove :id

    end
    create index(:user_chats, [:user_id])
    create index(:User_Keys, [:user_id])

  end
end
