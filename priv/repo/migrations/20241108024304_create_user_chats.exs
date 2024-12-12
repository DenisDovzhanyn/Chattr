defmodule Chattr.Repo.Migrations.CreateUserChats do
  use Ecto.Migration

  def change do
    drop table(:user_chats)
    create table(:user_chats) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :chat_id, references(:chats, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:user_chats, [:user_id, :chat_id])
  end
end
