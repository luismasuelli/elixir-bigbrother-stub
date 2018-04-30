defmodule BigBrother.Storage.Main.Models.User do
  @moduledoc """
  Users will perform many activities in the system
    and will have permissions, belong to groups, and
    perhaps be admins/staff.
  """

  alias BigBrother.Storage.Main.Models.Permission
  alias BigBrother.Storage.Main.Models.Group

  use Ecto.Schema

  schema "users" do
    field :username, :string
    field :password, :string
    field :hash_alg, :string, default: "no-password"
    field :active, :boolean, default: true
    field :last_login, :utc_datetime
    field :admin, :boolean, default: false
    many_to_many :groups, Group, join_through: "user_groups", unique: true
    many_to_many :permissions, Permission, join_through: "user_permissions", unique: true
    has_many :groups_permissions, through: [:groups, :permissions]
    timestamps(type: :utc_datetime)
  end

  defp now do
    DateTime.utc_now()
  end
end
