defmodule SandboxWeb.MealthyController do
  use SandboxWeb, :controller

  alias Sandbox.Mealthy

  def list_recipes(conn, _params) do
    render(conn, "list_recipes.html")
  end

  def edit_recipe(conn, %{"id" => id}) do
    recipe = Mealthy.get_recipe(id)
    render(conn, "edit_recipe.html", recipe: recipe)
  end
end
