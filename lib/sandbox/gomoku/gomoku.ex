defmodule Sandbox.Gomoku do
  alias Sandbox.Gomoku.Server

  defstruct [:player, :state, :color, :places, :id]

  @directions [
    :top_to_bottom,
    :left_to_right,
    :left_top_to_right_bottom,
    :left_bottom_to_right_top
  ]

  def get_server(id) do
    Server.get(id)
  end

  def new() do
    %__MODULE__{
      state: :start,
      player: :black,
      places: %{}
    }
  end

  def new(%{"id" => id, "socket_id" => socket_id}) do
    id = URI.decode_www_form(id)
    server = Server.get(id)

    player =
      case server.state do
        nil -> %{color: :black, state: :waiting}
        :waiting -> %{color: :white, state: :playing}
        _ -> %{color: nil, state: :watching}
      end

    server =
      Server.update(server, %{
        state: player.state,
        players: Map.put_new(server.players, socket_id, player)
      })

    Map.merge(
      %__MODULE__{
        player: server.player,
        places: server.places,
        id: id
      },
      server.players[socket_id]
    )
  end

  def start(gomoku, "local") do
    %{gomoku | state: :playing}
  end

  def start(gomoku, "online") do
    %{gomoku | id: Server.start_link()}
  end

  def start(gomoku) do
    %{gomoku | state: :playing}
  end

  def stop(%{state: :watching}), do: :nothing
  def stop(gomoku), do: gomoku.id |> get_server() |> Server.stop()

  def place(%{state: :stop} = gomoku, _), do: gomoku
  def place(%{id: nil} = gomoku, place), do: do_place(gomoku, place)

  def place(%{player: player, color: player} = gomoku, place) do
    gomoku = do_place(gomoku, place)

    gomoku.id
    |> Server.get()
    |> Server.update(%{places: gomoku.places, player: gomoku.player, state: gomoku.state})

    gomoku
  end

  def place(gomoku, _), do: gomoku

  defp do_place(gomoku, place) do
    [x, y] = place |> String.split(",") |> Enum.map(&String.to_integer/1)
    places = Map.put_new(gomoku.places, {x, y}, gomoku.player)

    if win?({x, y}, places) do
      %{gomoku | places: places, state: :stop}
    else
      player = if gomoku.player == :black, do: :white, else: :black
      %{gomoku | places: places, player: player}
    end
  end

  def place(gomoku) do
    server = Server.get(gomoku.id)
    %{gomoku | places: server.places, player: server.player, state: server.state}
  end

  defp win?(place, places) do
    place
    |> calculate_win_lists()
    |> Enum.any?(&Enum.all?(&1, fn p -> places[p] == places[place] end))
  end

  defp calculate_win_lists(place) do
    @directions
    |> Enum.map(&calculate_win_lists_by(&1, place))
    |> Enum.concat()
  end

  defp calculate_win_lists_by(direction, place) do
    Enum.reduce(0..4, [], fn i, lists ->
      (0 - i)..(4 - i)
      |> Enum.reduce_while([], fn j, list ->
        {x, y} = calculate_place(direction, place, j)

        if x < 0 || x > 14 || y < 0 || y > 14 do
          {:halt, nil}
        else
          {:cont, [{x, y} | list]}
        end
      end)
      |> case do
        nil -> lists
        list -> [Enum.reverse(list) | lists]
      end
    end)
  end

  defp calculate_place(:top_to_bottom, {x, y}, offset), do: {x, y + offset}
  defp calculate_place(:left_to_right, {x, y}, offset), do: {x + offset, y}
  defp calculate_place(:left_top_to_right_bottom, {x, y}, offset), do: {x + offset, y + offset}
  defp calculate_place(:left_bottom_to_right_top, {x, y}, offset), do: {x + offset, y - offset}
end
