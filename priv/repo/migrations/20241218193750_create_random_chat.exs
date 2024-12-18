defmodule Chattr.Repo.Migrations.CreateRandomChat do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :find_random_chat, :boolean
    end
  end
end
