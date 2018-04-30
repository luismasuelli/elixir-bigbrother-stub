defmodule BigBrother.Storage.Repositories.Main.Migrations.AddHashingAlgorithmForUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :hashalg, :string, size: 255, null: false, default: "no-password"
    end
  end
end
