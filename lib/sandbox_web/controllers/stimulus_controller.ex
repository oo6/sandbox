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

  def content_loader(conn, _params) do
    render(conn, "content_loader.html")
  end

  def date_time(conn, _params) do
    html(conn, "<p>#{DateTime.utc_now()}</p>")
  end
end
