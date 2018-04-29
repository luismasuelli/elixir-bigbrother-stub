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
    field :admin, :boolean, default: false
    many_to_many :groups, Group, join_through: "user_groups", unique: true
    many_to_many :permissions, Permission, join_through: "user_permissions", unique: true
    timestamps
  end
end
