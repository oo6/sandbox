defmodule Sandbox.Mealthy do
  use Sandbox, :context

  alias Sandbox.Mealthy.{Recipe, RecipeSearch}

  def search_recipes(opts \\ []) do
    opts = Enum.into(opts, %{})

    Recipe
    |> RecipeSearch.run(opts[:q])
    |> Repo.all()
  end

  def list_recipes() do
    Repo.all(Recipe)
  end

  def get_recipe(id) do
    Repo.get(Recipe, id)
  end

  def create_recipe(params) do
    %Recipe{}
    |> Recipe.changeset(params)
    |> Repo.insert()
  end

  def update_recipe(recipe, params) do
    recipe
    |> Recipe.changeset(params)
    |> Repo.update()
  end

  def delete_recipe(recipe) do
    Repo.delete(recipe)
  end
end
