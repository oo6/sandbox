defmodule SandboxWeb.GomokuLive do
  use SandboxWeb, :live_view

  alias Sandbox.Gomoku
  alias SandboxWeb.Live

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

  def render(assigns) do
    class =
      "max-w-screen-2xl h-screen mx-auto flex items-center justify-center " <>
        if assigns.gomoku.state == :start, do: "flex-row", else: "flex-col"

    ~L"""
    <div class= "<%= class %>" data-controller="gomoku">
      <%= render_by_state(@gomoku, @socket) %>
    </div>
    """
  end

  defp render_by_state(%Gomoku{state: :start}, _) do
    assigns = %{}

    ~L"""
    <button class="button-outline mr-4" phx-click="start_local">Local</button>
    <button class="button-outline" phx-click="start_online">Online</button>
    """
  end

  defp render_by_state(%Gomoku{state: :stop} = gomoku, _) do
    assigns = %{gomoku: gomoku}

    ~L"""
    <p>🎉 <%= @gomoku.player %> 🎉</p>
    <%= render_board(@gomoku) %>
    """
  end

  defp render_by_state(%Gomoku{state: :waiting, id: id}, socket) do
    render_invite(id, "play", socket)
  end

  defp render_by_state(gomoku, socket) do
    assigns = %{gomoku: gomoku, socket: socket}

    ~L"""
    <%= if @gomoku.id do%>
      <%= render_invite(@gomoku.id, "watch", @socket) %>
    <% end %>
    <%= render_board(@gomoku) %>
    """
  end

  defp render_invite(id, state, socket) do
    assigns = %{id: id, state: state, socket: socket}

    ~L"""
    Invite <%= @state %>:
    <input type="text" value="<%= Routes.live_url(@socket, __MODULE__, @id) %>" data-gomoku-target="source" readonly>
    <button class="button-outline" data-action="gomoku#copy">Copy</button>
    """
  end

  defp render_piece(x, y, gomoku) do
    class =
      cond do
        color = gomoku.places[{x, y}] ->
          bg_color = if color == :black, do: "bg-black", else: "bg-white"
          "gomoku-piece rounded-full cursor-not-allowed #{bg_color}"

        !gomoku.id || gomoku.player == gomoku.color ->
          bg_color = if gomoku.player == :black, do: "bg-black", else: "bg-white"
          "gomoku-piece rounded-full hover\:opacity-60 hover\:#{bg_color}"

        true ->
          ""
      end

    assigns = %{place: "#{x},#{y}", class: class}

    ~L"""
    <span phx-click="place" phx-value-place="<%= @place %>" class="<%= @class %>"></span>
    """
  end

  defp render_board(gomoku) do
    assigns = %{gomoku: gomoku}

    ~L"""
    Black
    <%= if @gomoku.color == :black, do: "👀" %>
    <%= if @gomoku.player == :black, do: "🤞" %>
    vs White
    <%= if @gomoku.color == :white, do: "👀" %>
    <%= if @gomoku.player == :white, do: "🤞" %>

    <div class="gomoku-board flex flex-wrap">
      <%= for x <- 0..14, y <- 0..14 do %>
        <%= render_piece(x, y, @gomoku) %>
      <% end %>
    </div>
    """
  end
end
