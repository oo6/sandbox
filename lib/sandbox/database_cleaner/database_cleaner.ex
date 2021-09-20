defmodule Sandbox.DatabaseCleaner do
  use GenServer

  require Logger

  def start_link(opts) do
    name = Keyword.get(opts, :name, __MODULE__)
    timeout = Keyword.get(opts, :timeout)

    GenServer.start_link(__MODULE__, timeout, name: name)
  end

  @impl true
  def init(timeout) do
    schedule(timeout)
    {:ok, timeout}
  end

  @impl true
  def handle_info(:execute, timeout) do
    log("deleting outdated records...")

    Task.start(fn ->
      random = :rand.uniform(1_000)
      Process.sleep(random)

      # Logger.info("#{__MODULE__} #{random} records deleted")
    end)

    schedule(timeout)

    {:noreply, timeout}
  end

  defp schedule(timeout) do
    log("scheduling for #{timeout}ms...")
    Process.send_after(self(), :execute, timeout)
  end

  defp log(_msg) do
    # Logger.info("----[#{node()}] #{__MODULE__} #{msg}")
  end
end
