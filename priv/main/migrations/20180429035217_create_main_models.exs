defmodule BigBrother.Storage.Repositories.Main.Migrations.CreateMainModels do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, null: false, size: 255
      add :password, :string, null: false, size: 255
    end

    create table(:groups) do
      add :code, :string, null: false, size: 100
      add :name, :string, null: false, size: 255
    end

    create table(:permissions) do
      add :code, :string, null: false, size: 100
      add :name, :string, null: false, size: 255
    end

    create index(:users, [:username], unique: true)
    create index(:groups, [:code], unique: true)
    create index(:permissions, [:code], unique: true)

    create table(:user_groups, primary_key: false) do
      add :user_id, references(:users), null: false
      add :group_id, references(:groups), null: false
    end

    create index(:user_groups, [:user_id, :group_id], unique: true)

    create table(:user_permissions, primary_key: false) do
      add :user_id, references(:users), null: false
      add :permission_id, references(:permissions), null: false
    end

    create index(:user_permissions, [:user_id, :permission_id], unique: true)

    create table(:group_permissions, primary_key: false) do
      add :group_id, references(:groups), null: false
      add :permission_id, references(:permissions), null: false
    end

    create index(:group_permissions, [:group_id, :permission_id], unique: true)
  end
end
