defmodule Chattr.Repo.Migrations.UpdateUserChatsTable do
  use Ecto.Migration

  def change do

    execute("ALTER TABLE user_chats DROP CONSTRAINT user_chats_pkey;")
  end
end
