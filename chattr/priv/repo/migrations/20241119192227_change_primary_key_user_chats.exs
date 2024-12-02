defmodule Chattr.Repo.Migrations.ChangePrimaryKeyUserChats do
  use Ecto.Migration

  def change do
    alter table(:user_chats) do
      remove :id
      modify :user_id, :bigint, primary_key: true
    end
  end
end
