defmodule SandboxWeb.GomokuLiveTest do
  use SandboxWeb.ConnCase

  import Phoenix.LiveViewTest

  setup %{conn: conn} do
    {:ok, view, _html} = live(conn, "/gomoku")
    {:ok, view: view}
  end

  test "redirected mount", %{conn: conn} do
    assert {:error, {:live_redirect, %{to: "/gomoku"}}} = live(conn, "/gomoku/invalid_id")
  end

  test "click start_local", %{view: view} do
    view = render_click(view, "start_local")
    assert ~r(<span phx-click="place" .*?></span>)s |> Regex.scan(view) |> length() == 225
  end

  test "click start_online", %{view: view} do
    assert render_click(view, "start_online") =~ "Invite play"
  end

  test "click place", %{view: view} do
    render_click(view, "start_local")

    assert render_click(view, "place", %{"place" => "0,0"}) =~
             "<span phx-click=\"place\" phx-value-place=\"0,0\" class=\"piece black disabled\"></span>"
  end
end
