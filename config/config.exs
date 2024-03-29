# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :sandbox,
  ecto_repos: [Sandbox.Repo]

# Configures the endpoint
config :sandbox, SandboxWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: SandboxWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Sandbox.PubSub,
  live_view: [signing_salt: "+8pG0vP2"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :grpc, start_server: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
