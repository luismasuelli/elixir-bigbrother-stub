defmodule BigBrother.Storage.Repositories.Main.Migrations.AddAdminFlagToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :admin, :boolean, default: false, null: false
    end
  end
end
