defmodule SandboxWeb.ImageController do
  use SandboxWeb, :controller

  alias Sandbox.SnippyCrab
  alias Sandbox.SnippyCrab.Image

  def index(conn, _params) do
    changeset = Image.changeset(%Image{}, %{})
    render(conn, "index.html", changeset: changeset)
  end

  def create(conn, %{"image" => image_params}) do
    changeset = Image.changeset(%Image{}, image_params)

    if changeset.valid? do
      %{file: %{path: path}, x: x, y: y, width: width, height: height} = changeset.changes

      image =
        path
        |> File.read!()
        |> SnippyCrab.crop_and_grayscale(x, y, width, height)

      render(conn, "show.html", image: "data:image/png;base64,#{Base.encode64(image)}")
    else
      render(conn, "index.html", changeset: changeset)
    end
  end
end
