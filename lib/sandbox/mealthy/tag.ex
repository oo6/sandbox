defmodule Sandbox.Mealthy.Tag do
  use Sandbox, :schema

  alias Sandbox.Mealthy.{Recipe, RecipeTag}

  schema "mealthy_tags" do
    field :name, :string

    many_to_many :recipes, Recipe, join_through: RecipeTag

    timestamps()
  end

  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
