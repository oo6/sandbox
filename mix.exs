defmodule Sandbox.MixProject do
  use Mix.Project

  def project do
    [
      app: :sandbox,
      version: "0.0.1",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Sandbox.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon],
      start_phases: [after_start: []]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.6.2"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.7"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.16"},
      {:floki, ">= 0.30.0"},
      {:phoenix_live_dashboard, "~> 0.5"},
      {:telemetry, "~> 1.0", override: true},
      {:telemetry_metrics, "~> 0.6", override: true},
      {:telemetry_poller, "~> 1.0", override: true},
      {:ecto_psql_extras, "~> 0.2"},
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      {:ex_machina, "~> 2.7", only: :test},
      {:absinthe, "~> 1.5"},
      {:absinthe_plug, "~> 1.5"},
      {:dataloader, "~> 1.0"},
      {:httpoison, "~> 1.7"},
      {:money, "~> 1.7"},
      {:libcluster, "~> 3.3"},
      {:horde, "~> 0.8"},
      {:stream_data, "~> 0.5", only: [:dev, :test]}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "deps.get": ["deps.get", "cmd cd assets && yarn install"],
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test", "cmd cd assets && yarn test"]
    ]
  end
end
