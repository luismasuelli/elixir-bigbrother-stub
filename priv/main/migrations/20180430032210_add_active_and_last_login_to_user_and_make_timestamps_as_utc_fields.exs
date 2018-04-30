defmodule BigBrother.Storage.Repositories.Main.Migrations.AddActiveAndLastLoginToUserAndMakeTimestampsAsUtcFields do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :active, :boolean, null: false, default: true
      add :last_login, :utc_datetime, null: true
      modify :inserted_at, :utc_datetime
      modify :updated_at, :utc_datetime
    end
  end
end
