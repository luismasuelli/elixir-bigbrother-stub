defmodule BigBrother.Storage.Main.Models.Group do
  @moduledoc """
  A group users can belong to. Groups will have
    permissions all users therein will have as
    base permissions.
  """

  alias BigBrother.Storage.Main.Models.Permission
  alias BigBrother.Storage.Main.Models.User

  use Ecto.Schema

  schema "groups" do
    field :name, :string
    field :code, :string
    many_to_many :users, User, join_through: "user_groups", unique: true
    many_to_many :permissions, Permission, join_through: "group_permissions", unique: true
  end
end
