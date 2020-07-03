defmodule SandboxWeb.GomokuLive do
  use Phoenix.LiveView

  alias Sandbox.Gomoku
  alias SandboxWeb.Live

  def render(assigns) do
    SandboxWeb.GomokuView.render("index.html", assigns)
  end

  def mount(%{"id" => id}, _session, socket) do
    server = Gomoku.get_server(id)

    if server do
      {:ok, socket}
    else
      {:ok, push_redirect(socket, to: "/gomoku", replace: true)}
    end
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def unmount(_, %{gomoku: gomoku}) do
    with :ok <- Gomoku.stop(gomoku) do
      Phoenix.PubSub.broadcast_from!(Sandbox.PubSub, self(), gomoku.id, :stop)
    end
  end

  def handle_params(%{"id" => _} = params, _, socket) do
    gomoku = params |> Map.put("socket_id", socket.id) |> Gomoku.new()

    if gomoku.state == :playing do
      Phoenix.PubSub.broadcast(Sandbox.PubSub, gomoku.id, :start)
    end

    if connected?(socket) do
      Live.monitor(self(), __MODULE__, %{gomoku: gomoku})
      Phoenix.PubSub.subscribe(Sandbox.PubSub, gomoku.id)
    end

    {:noreply, assign(socket, gomoku: gomoku)}
  end

  def handle_params(_, _, socket) do
    {:noreply, assign(socket, gomoku: Gomoku.new())}
  end

  def handle_event("start_local", _, socket) do
    {:noreply, assign(socket, gomoku: Gomoku.start(socket.assigns.gomoku, "local"))}
  end

  def handle_event("start_online", _, socket) do
    gomoku = Gomoku.start(socket.assigns.gomoku, "online")
    path = "/gomoku/#{URI.encode_www_form(gomoku.id)}"

    {:noreply, push_patch(socket, to: path, replace: true)}
  end

  def handle_event("place", %{"place" => place}, socket) do
    gomoku = Gomoku.place(socket.assigns.gomoku, place)

    if gomoku.id do
      Phoenix.PubSub.broadcast_from!(Sandbox.PubSub, self(), gomoku.id, :place)
    end

    socket |> assign(gomoku: gomoku) |> win?()
  end

  def handle_info(:start, socket) do
    {:noreply, assign(socket, gomoku: Gomoku.start(socket.assigns.gomoku))}
  end

  def handle_info(:place, socket) do
    socket
    |> assign(gomoku: Gomoku.place(socket.assigns.gomoku))
    |> win?()
  end

  def handle_info(:stop, socket) do
    {:noreply, push_patch(socket, to: "/gomoku", replace: true)}
  end

  defp win?(%{assigns: %{gomoku: %{state: :stop}}} = socket), do: {:noreply, socket}
  defp win?(socket), do: {:noreply, socket}
end
