defmodule BigBrother.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc """
  Stub application supporting these features:
  - User authentication / permissions
  - WebSockets
  - Logging? Perhaps later
  """

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: BigBrother.Worker.start_link(arg)
      # {BigBrother.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BigBrother.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
