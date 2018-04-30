defmodule BigBrother.Storage.Repositories.Main do
  use Ecto.Repo, otp_app: :big_brother

  defmodule Error do
    defexception :message, :code
  end

  # A user in this case will not be able to login.
  #   For other cases, please import the appropriate
  #   password hashing library. These algorithms are
  #   pretty strong/secure.
  # requires: {:argon2_elixir, "~> 1.2"}
  defp get_hasher("argon2"), do: Comeonin.Argon2
  # requires: {:bcrypt_elixir, "~> 1.0"}
  defp get_hasher("bcrypt"), do: Comeonin.Bcrypt
  # requires: {:pbkdf2_elixir, "~> 0.12"}
  defp get_hasher("pbkdf2"), do: Comeonin.Pbkdf2
  # invalid hasher
  defp get_hasher(v) when is_string(v) do
    raise %Error{message: "Invalid hasher. Supported hashers are: argon2, \
                           bcrypt, and pbkdf2", code: :invalid_hasher}
  end
  # requires: depends on the library in config
  defp get_hasher(v) when is_atom(v), do: get_hasher(Kernel.to_string(v))
  defp get_hasher(nil) do
    case Application.get_env(:big_brother, :hasher) do
      nil -> raise %Error{message: "No `hasher:` key specified for :big_brother configuration. \
                                    Please add something like: `config :big_brother, hasher: \"argon2\"` \
                                    to your config.exs file. You can specify argon2, bcrypt, or pbkdf2 \
                                    either as strings or atoms", code: :missing_hasher_config}
      name when is_atom(name) or is_string(name) -> get_hasher(name)
      _ -> raise %Error{message: "Invalid `hasher:` key type configured. Only atoms \
                                  and strings are supported", code: :invalid_hasher_config}
    end
  end
end
