defmodule SandboxWeb.StimulusController do
  use SandboxWeb, :controller

  def hello(conn, _params) do
    render(conn, "hello.html")
  end

  def clipboard(conn, _params) do
    render(conn, "clipboard.html")
  end

  def slideshow(conn, _params) do
    render(conn, "slideshow.html")
  end

  def content_loader_vs_live_view(conn, _params) do
    render(conn, "content_loader_vs_live_view.html", content_loader: DateTime.utc_now())
  end

  def date_time(conn, _params) do
    now = DateTime.utc_now() |> DateTime.to_string()
    html(conn, "<p>#{now}</p>")
  end
end
