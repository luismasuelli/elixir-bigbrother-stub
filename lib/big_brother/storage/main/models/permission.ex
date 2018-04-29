defmodule BigBrother.Storage.Main.Models.Permission do
  @moduledoc """
  A permission object to be checked. Users and groups
    will have permmissions.
  """

  use Ecto.Schema

  schema "permissions" do
    field :name, :string
    field :code, :string
  end
end
