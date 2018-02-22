defmodule Sandbox.Mealthy do
  use Sandbox, :context

  alias Sandbox.Mealthy.{Recipe, RecipeSearch}

  def search_recipes(opts \\ []) do
    opts = Enum.into(opts, %{})

    Recipe
    |> RecipeSearch.run(opts[:q])
    |> Repo.all()
  end
end
