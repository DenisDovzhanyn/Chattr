defmodule Chattr.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    drop table(:messages)
    create table(:messages) do
      add :sent_time, :utc_datetime
      add :content, :text
      add :chat_id, references(:chats, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:messages, [:chat_id])
    create index(:messages, [:user_id])
  end
end
