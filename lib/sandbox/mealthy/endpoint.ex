defmodule Sandbox.Mealthy.Endpoint do
  use GRPC.Endpoint

  intercept GRPC.Logger.Server
  run Sandbox.Mealthy.Recipe.Server
end

defmodule Sandbox.Mealthy.Recipe.Server do
  use GRPC.Server, service: Sandbox.Mealthy.Recipe.Service

  alias Sandbox.Mealthy
  alias Sandbox.Mealthy.RecipeReply

  def create(%{title: title, description: description}, _stream) do
    with {:ok, recipe} <- Mealthy.create_recipe(%{title: title, description: description}) do
      RecipeReply.new(recipe)
    end
  end

  def get(%{id: id}, _stream) do
    recipe = Sandbox.Mealthy.get_recipe(id)

    if recipe do
      RecipeReply.new(recipe)
    else
      raise GRPC.RPCError, status: :not_found
    end
  end
end
