defmodule Sandbox.SnippyCrab.Image do
  use Sandbox, :schema

  schema "snippy_crab_images" do
    field :file, :map
    field :height, :integer
    field :width, :integer
    field :x, :integer
    field :y, :integer

    timestamps()
  end

  def changeset(image, attrs) do
    image
    |> cast(attrs, [:file, :x, :y, :width, :height])
    |> validate_required([:file, :x, :y, :width, :height])
  end
end
