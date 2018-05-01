defmodule BigBrother.Storage.Repositories.Main do
  use Ecto.Repo, otp_app: :big_brother

  alias BigBrother.Storage.Main.Models.User
  alias BigBrother.Storage.Main.Models.Group
  alias BigBrother.Storage.Main.Models.Permission

  def register(%{} = data, opts \\ []) do
    insert(User.register(data, opts))
  end
end
