defmodule BigBrother.Storage.Main.Models.User do
  @moduledoc """
  Users will perform many activities in the system
    and will have permissions, belong to groups, and
    perhaps be admins/staff.
  """

  defmodule Error do
    defexception [:message, :code]
  end

  alias BigBrother.Storage.Main.Models.Permission
  alias BigBrother.Storage.Main.Models.Group
  alias BigBrother.Utils.Models, as: ModelUtils
  alias __MODULE__, as: This

  use Ecto.Schema

  schema "users" do
    field :username, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :hashed_password, :string, default: ""
    field :hash_alg, :string, default: "no-password"
    field :active, :boolean, default: true
    field :last_login, :utc_datetime
    field :admin, :boolean, default: false
    many_to_many :groups, Group, join_through: "user_groups", unique: true
    many_to_many :permissions, Permission, join_through: "user_permissions", unique: true
    has_many :groups_permissions, through: [:groups, :permissions]
    timestamps(type: :utc_datetime)
  end

  # Returns a changeset suitable for insertion.
  def register(%{} = data, opts \\ []) do
    [admin, hash_alg] = BigBrother.Utils.Misc.get_keywords(opts, [admin: false, hash_alg: nil])
    # Starting with a brand-new user
    %This{}
    # Perhaps allowing more fields? (e.g. email, email_confirmation)
    |> Ecto.Changeset.cast(data, [:username, :password, :password_confirmation])
    |> Ecto.Changeset.cast(%{admin: admin}, [:admin])
    # Perhaps adding more normalizations? (e.g. adding email)
    |> ModelUtils.normalize_text_fields([:username], [:trim, :downcase])
    # Perhaps requiring more fields?
    |> Ecto.Changeset.validate_required([:username, :password, :password_confirmation], message: "must be present and " <>
                                                                                                 "non-spacey")
    # Add other validations here, like this one:
    |> Ecto.Changeset.validate_format(:username, ~r/[a-z][a-z0-9_]*/, message: "must start with a letter and continue " <>
                                                                               "with letters, numbers, and underscore")
    # Perhaps confirming more fields? (e.g. email, email_confirmation)
    |> Ecto.Changeset.validate_confirmation(:password, message: "must match confirmation")
    # Fixing the passwords, ready to registration
    |> fix_password(hash_alg)
  end

  # On a valid changeset, with :password present,
  #   sets the new password according to hash_alg.
  # Returns a changet with :hashed_password field,
  #   and no more :password nor :password_confirmation
  #   fields.
  defp fix_password(changeset, hash_alg) do
    IO.inspect hash_alg
    {hash_module, hash_alg} = get_hasher(hash_alg)
    password = Ecto.Changeset.get_field(changeset, :password)
    password_confirmation = Ecto.Changeset.get_field(changeset, :password_confirmation)
    if password != nil and password != "" and password == password_confirmation do
      Ecto.Changeset.cast(changeset, %{
        password: nil, password_confirmation: nil, hash_alg: hash_alg,
        hashed_password: hash_module.hashpwsalt(password)
      }, [:password, :password_confirmation, :hashed_password, :hash_alg])
    else
      changeset
    end
  end

  # Gets the involved hash algorithm, by its name.
  # If absent, tries to get it from the app config.
  # requires: {:argon2_elixir, "~> 1.2"}
  defp get_hasher("argon2" = name), do: {Comeonin.Argon2, name}
  # requires: {:bcrypt_elixir, "~> 1.0"}
  defp get_hasher("bcrypt" = name), do: {Comeonin.Bcrypt, name}
  # requires: {:pbkdf2_elixir, "~> 0.12"}
  defp get_hasher("pbkdf2" = name), do: {Comeonin.Pbkdf2, name}
  # invalid hasher
  defp get_hasher(v) when is_binary(v) do
    raise %Error{message: "Invalid hasher. Supported hashers are: argon2, " <>
                          "bcrypt, and pbkdf2", code: :invalid_hasher}
  end
  # requires: depends on the library in config
  defp get_hasher(v) when is_atom(v) and v != nil, do: get_hasher(Kernel.to_string(v))
  defp get_hasher(nil) do
    case Application.get_env(:big_brother, :hasher) do
      nil -> raise %Error{message: "No `hasher:` key specified for :big_brother configuration. " <>
                                   "Please add something like: `config :big_brother, hasher: \"argon2\"` " <>
                                   "to your config.exs file. You can specify argon2, bcrypt, or pbkdf2 " <>
                                   "either as strings or atoms", code: :missing_hasher_config}
      name when is_atom(name) or is_binary(name) -> get_hasher(name)
      _ -> raise %Error{message: "Invalid `hasher:` key type configured. Only atoms " <>
                                 "and strings are supported", code: :invalid_hasher_config}
    end
  end
end
