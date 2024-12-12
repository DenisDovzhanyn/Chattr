defmodule Chattr.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    drop table(:users)
    create table(:users) do
      add :username, :string
      add :display_name, :string
      add :password, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:password])
    create unique_index(:users, [:username])
  end
end
