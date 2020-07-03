defmodule SandboxWeb.StimulusLive do
  use SandboxWeb, :live_view

  def render(assigns) do
    ~L"""
      live view:
      <div><p><%= @live_view %></p></div>
    """
  end

  def mount(_params, _session, socket) do
    Process.send_after(self(), :update, 1000)

    {:ok, assign(socket, live_view: DateTime.utc_now())}
  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 1000)

    {:noreply, assign(socket, live_view: DateTime.utc_now())}
  end
end
