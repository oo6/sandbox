# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :sandbox,
  ecto_repos: [Sandbox.Repo]

# Configures the endpoint
config :sandbox, SandboxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "rimJoCHkSxmzxX+2+3IGB5ssSRNHYoALqDcWQzzAWLgjOJoG/xA/8l2Z/P8PuTjl",
  render_errors: [view: SandboxWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Sandbox.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "0sgnJR27dSMOMcFJYlONH+PiFb/8kUf0kITx6xfzTM6hQfKjsE+XCSgAx4Bpm7CU"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix,
  json_library: Jason,
  template_engines: [leex: Phoenix.LiveView.Engine]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
