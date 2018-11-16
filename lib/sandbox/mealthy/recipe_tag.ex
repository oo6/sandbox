defmodule Sandbox.Mealthy.RecipeTag do
  use Sandbox, :schema

  alias Sandbox.Mealthy.{Recipe, Tag}

  @primary_key false
  schema "mealthy_recipes_tags" do
    belongs_to :recipe, Recipe
    belongs_to :tag, Tag

    timestamps()
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:recipe_id, :tag_id])
    |> validate_required([:recipe_id, :tag_id])
    |> foreign_key_constraint(:recipe_id)
    |> foreign_key_constraint(:tag_id)
  end
end
