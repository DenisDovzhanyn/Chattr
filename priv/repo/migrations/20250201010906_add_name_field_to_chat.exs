defmodule Chattr.Repo.Migrations.AddNameFieldToChat do
  use Ecto.Migration

  def change do
    alter table(:chats) do
      add :chat_name, :string
    end
  end
end
