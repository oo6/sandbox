defmodule Sandbox.Mealthy.Recipe do
  use Sandbox, :schema

  alias Sandbox.Mealthy.{Tag, RecipeTag}

  schema "mealthy_recipes" do
    field(:title, :string)
    field(:description, :string)

    many_to_many(:tags, Tag, join_through: RecipeTag)

    timestamps()
  end

  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end
