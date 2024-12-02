defmodule Chattr.Repo.Migrations.CreateChats do
  use Ecto.Migration

  def change do
    drop table(:chats)
    create table(:chats) do
      add :last_msg_time, :utc_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
