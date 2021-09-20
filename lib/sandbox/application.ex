defmodule Sandbox.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias Sandbox.DatabaseCleaner.{
    GlobalSupervisor,
    HordeRegistry,
    HordeSupervisor,
    HordeNodeObserver
  }

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Sandbox.Repo,
      # Start the Telemetry supervisor
      SandboxWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Sandbox.PubSub},
      # Start the Endpoint (http/https)
      SandboxWeb.Endpoint,
      # Start a worker by calling: Sandbox.Worker.start_link(arg)
      # {Sandbox.Worker, arg}
      SandboxWeb.Live,
      {Registry, name: Sandbox.BookStore.BookRegistry, keys: :unique},
      Sandbox.BookStore.BookSupervisor,
      Sandbox.BookStore.BookStateHydrator,
      {Cluster.Supervisor,
       [
         [database_cleaner: [strategy: Cluster.Strategy.Gossip]],
         [name: Sandbox.ClusterSupervisor]
       ]},
      {GlobalSupervisor, [timeout: :timer.seconds(2)]},
      HordeRegistry,
      HordeSupervisor,
      HordeNodeObserver
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sandbox.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SandboxWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def start_phase(:after_start, _, _) do
    HordeSupervisor.start_server(timeout: :timer.seconds(2))
    :ok
  end
end
