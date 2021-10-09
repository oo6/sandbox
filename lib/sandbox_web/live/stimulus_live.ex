defmodule SandboxWeb.StimulusLive do
  use SandboxWeb, :live_view

  def render(assigns) do
    ~H"""
      live view:
      <div><p><%= @now %></p></div>
    """
  end

  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 1000)

    {:ok, assign(socket, now: DateTime.utc_now())}
  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 1000)

    {:noreply, assign(socket, now: DateTime.utc_now() |> DateTime.to_string())}
  end
end
