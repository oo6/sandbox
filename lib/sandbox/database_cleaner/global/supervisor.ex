defmodule Sandbox.DatabaseCleaner.GlobalSupervisor do
  use GenServer

  alias Sandbox.DatabaseCleaner

  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    pid = start_and_monitor(opts)

    {:ok, {pid, opts}}
  end

  @impl true
  def handle_info({:DOWN, _, :process, pid, _reason}, {pid, opts}) do
    {:noreply, {start_and_monitor(opts), opts}}
  end

  defp start_and_monitor(opts) do
    pid =
      case DatabaseCleaner.start_link([{:name, {:global, DatabaseCleaner}} | opts]) do
        {:ok, pid} -> pid
        {:error, {:already_started, pid}} -> pid
      end

    Process.monitor(pid)
    pid
  end
end
