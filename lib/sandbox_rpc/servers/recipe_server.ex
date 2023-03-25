defmodule SandboxRPC.RecipeServer do
  use SandboxRPC, service: Sandbox.Mealthy.Recipe.Service

  alias Sandbox.Mealthy

  def create(%{title: title, description: description}, stream) do
    with {:ok, recipe} <- Mealthy.create_recipe(%{title: title, description: description}) do
      render(stream, recipe)
    end
  end

  def get(%{id: id}, stream) do
    recipe = Mealthy.get_recipe!(id)
    render(stream, recipe)
  end
end
