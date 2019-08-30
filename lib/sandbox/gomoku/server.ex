defmodule Sandbox.Gomoku.Server do
  def start_link() do
    {:ok, pid} = Agent.start(fn -> %{state: nil, player: :black, places: %{}, players: %{}} end)

    Agent.update(pid, &Map.put(&1, :pid, pid))

    pid |> :erlang.term_to_binary() |> Base.encode64()
  end

  def get(id) do
    case Base.decode64(id) do
      {:ok, binary} ->
        pid = :erlang.binary_to_term(binary)

        if is_pid(pid) do
          if Process.alive?(pid), do: Agent.get(pid, & &1), else: nil
        else
          nil
        end

      _ ->
        nil
    end
  end

  def update(%{pid: pid}, params) do
    Agent.update(pid, &Map.merge(&1, params))
    Agent.get(pid, & &1)
  end

  def stop(%{pid: pid}) do
    if Process.alive?(pid), do: Agent.stop(pid, {:shutdown, :closed}), else: :ok
  end
end
