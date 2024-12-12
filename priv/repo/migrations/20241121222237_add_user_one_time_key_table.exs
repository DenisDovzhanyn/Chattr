defmodule Chattr.Repo.Migrations.AddUserOneTimeKeyTable do
  use Ecto.Migration

  def change do
    create table(:User_Keys) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :key, :string

    end
  end
end
