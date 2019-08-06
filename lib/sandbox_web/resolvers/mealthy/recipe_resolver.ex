defmodule SandboxWeb.Mealthy.RecipeResolver do
  alias Sandbox.Mealthy

  def list(_parent, _args, _resolution) do
    {:ok, Mealthy.list_recipes()}
  end

  def get(_parent, %{id: id}, _resolution) do
    {:ok, Mealthy.get_recipe(id)}
  end

  def create(_parent, args, _resolution) do
    Mealthy.create_recipe(args)
  end

  def update(_parent, %{id: id} = args, _resolution) do
    id
    |> Mealthy.get_recipe()
    |> Mealthy.update_recipe(args)
  end

  def delete(_parent, %{id: id}, _resolution) do
    id
    |> Mealthy.get_recipe()
    |> Mealthy.delete_recipe()
  end

  def search(_parent, %{q: q}, _resolution) do
    {:ok, Mealthy.search_recipes(q: q)}
  end
end
