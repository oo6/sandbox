defmodule Sandbox.DatabaseCleaner.HordeSupervisor do
  use Horde.DynamicSupervisor

  alias Sandbox.DatabaseCleaner
  alias Sandbox.DatabaseCleaner.HordeRegistry

  require Logger

  def start_link(init_arg) do
    Horde.DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(init_arg) do
    [strategy: :one_for_one, members: members()]
    |> Keyword.merge(init_arg)
    |> Horde.DynamicSupervisor.init()
  end

  defp members() do
    Enum.map([Node.self() | Node.list()], &{__MODULE__, &1})
  end

  def start_server(opts) do
    name = opts |> Keyword.get(:name, DatabaseCleaner) |> via_tuple()
    new_opts = Keyword.put(opts, :name, name)
    child_spec = %{id: DatabaseCleaner, start: {DatabaseCleaner, :start_link, [new_opts]}}

    Horde.DynamicSupervisor.start_child(__MODULE__, child_spec)

    :ignore
  end

  def whereis(name \\ DatabaseCleaner) do
    name
    |> via_tuple()
    |> GenServer.whereis()
  end

  defp via_tuple(name) do
    {:via, Horde.Registry, {HordeRegistry, name}}
  end
end
