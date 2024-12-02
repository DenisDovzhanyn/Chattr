defmodule Chattr.Repo.Migrations.RemoveInsertedAtColumn do
  use Ecto.Migration

  def change do
    alter table(:chats) do
      remove :inserted_at
      remove :updated_at
    end

    alter table(:user_chats) do
      remove :inserted_at
      remove :updated_at
    end

    alter table(:messages) do
      remove :sent_time
      remove :updated_at
    end

    alter table(:users) do
      remove :inserted_at
      remove :updated_at
    end
  end
end
