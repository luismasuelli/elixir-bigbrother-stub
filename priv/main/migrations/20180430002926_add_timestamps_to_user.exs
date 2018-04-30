defmodule BigBrother.Storage.Repositories.Main.Migrations.AddTimestampsToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      timestamps
    end
  end
end
