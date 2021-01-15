defmodule Sandbox.GomokuTest do
  use Sandbox.DataCase

  alias Sandbox.Gomoku
  alias Sandbox.Gomoku.Server

  test "new game with online mode" do
    id = Server.start_link()

    assert %{
             player: :black,
             places: %{},
             id: id,
             color: :black,
             state: :waiting
           } = Gomoku.new(%{"id" => id, "socket_id" => "first_player"})

    server = Gomoku.get_server(id)
    assert :waiting == server.state

    assert %{
             player: :black,
             places: %{},
             id: id,
             color: :white,
             state: :playing
           } = Gomoku.new(%{"id" => id, "socket_id" => "second_player"})

    server = Gomoku.get_server(id)
    assert :playing == server.state

    assert %{
             player: :black,
             places: %{},
             id: id,
             color: nil,
             state: :watching
           } = Gomoku.new(%{"id" => id, "socket_id" => "other_player"})

    server = Gomoku.get_server(id)
    assert :watching == server.state
  end

  describe "start game with" do
    setup do
      {:ok, gomoku: Gomoku.new()}
    end

    test "local mode", %{gomoku: gomoku} do
      assert :playing == Gomoku.start(gomoku, "local").state
    end

    test "online mode", %{gomoku: gomoku} do
      assert Gomoku.start(gomoku, "online").id
    end

    test "broadcast", %{gomoku: gomoku} do
      assert :playing == Gomoku.start(gomoku).state
    end
  end

  test "stop game" do
    id = Server.start_link()
    Process.unlink(Gomoku.get_server(id).pid)

    assert :ok == Gomoku.stop(%{state: :playing, id: id})
    assert :nothing == Gomoku.stop(%{state: :watching})
  end

  describe "place piece with" do
    test "stop" do
      gomoku = %{state: :stop}
      assert gomoku == Gomoku.place(gomoku, "0,0")
    end

    test "local mode" do
      gomoku = %{id: nil, player: :black, places: %{}}

      assert %{
               id: nil,
               player: :white,
               places: %{{0, 0} => :black}
             } == Gomoku.place(gomoku, "0,0")
    end

    test "online mode and current player" do
      id = Server.start_link()
      gomoku = %{id: id, player: :black, places: %{}, color: :black, state: :playing}

      assert %{
               id: id,
               player: :white,
               places: %{{0, 0} => :black},
               color: :black,
               state: :playing
             } == Gomoku.place(gomoku, "0,0")
    end

    test "online mode and not current player" do
      id = Server.start_link()
      gomoku = %{id: id, player: :black, color: :white}

      assert gomoku == Gomoku.place(gomoku, "0,0")
    end

    test "online mode and other player" do
      id = Server.start_link()
      gomoku = %{id: id, player: :black, color: nil}

      assert gomoku == Gomoku.place(gomoku, "0,0")
    end

    test "win" do
      gomoku =
        Gomoku.place(
          %{
            id: nil,
            player: :black,
            places: %{
              {0, 0} => :black,
              {1, 0} => :black,
              {2, 0} => :black,
              {3, 0} => :black
            },
            state: :playing
          },
          "4,0"
        )

      assert :black == gomoku.places[{4, 0}]
      assert :stop == gomoku.state
    end
  end
end
