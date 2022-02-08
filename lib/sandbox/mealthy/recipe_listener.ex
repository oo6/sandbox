defmodule Sandbox.RecipeListener do
  use GenServer

  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    with {:ok, _pid, _ref} <- Sandbox.Repo.listen("mealthy_recipes_changed") do
      {:ok, opts}
    else
      error -> {:stop, error}
    end
  end

  @impl true
  def handle_info({:notification, _pid, _ref, "mealthy_recipes_changed", payload}, _state) do
    with {:ok, data} <- Jason.decode(payload) do
      data |> inspect() |> Logger.error()
    end

    {:noreply, :event_handled}
  end
end
