defmodule SandboxWeb.Live do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def monitor(pid, view_module, params \\ %{}) do
    GenServer.call(__MODULE__, {:monitor, pid, view_module, params})
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call({:monitor, pid, view_module, params}, _, state) do
    Process.monitor(pid)
    {:reply, :ok, Map.put(state, pid, {view_module, params})}
  end

  def handle_info({:DOWN, _, :process, pid, reason}, state) do
    {{module, params}, new_state} = Map.pop(state, pid)
    function_exported?(module, :unmount, 2) && module.unmount(reason, params)

    {:noreply, new_state}
  end
end
