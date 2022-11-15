defmodule SandboxRPC.RecipeServerTest do
  use Sandbox.DataCase

  import Sandbox.MealthyFactory

  alias Sandbox.Mealthy.{CreateRecipeRequest, GetRecipeRequest, Recipe}

  setup do
    {:ok, channel} = GRPC.Stub.connect("localhost:50051")
    {:ok, channel: channel}
  end

  test "create recipe", %{channel: channel} do
    request = CreateRecipeRequest.new(title: "Strawberry")
    assert {:ok, %{title: "Strawberry"}} = Recipe.Stub.create(channel, request)
  end

  describe "get recipe" do
    test "", %{channel: channel} do
      %{id: id} = insert(:recipe, title: "Strawberry")
      request = GetRecipeRequest.new(id: id)
      assert {:ok, %{id: ^id, title: "Strawberry"}} = Recipe.Stub.get(channel, request)
    end

    test "not found", %{channel: channel} do
      request = GetRecipeRequest.new(id: 0)
      assert {:error, %GRPC.RPCError{}} = Recipe.Stub.get(channel, request)
    end
  end
end
