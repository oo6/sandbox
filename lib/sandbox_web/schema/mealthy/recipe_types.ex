defmodule SandboxWeb.Schema.Mealthy.RecipeTypes do
  use Absinthe.Schema.Notation

  alias SandboxWeb.Mealthy.RecipeResolver

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :recipe do
    field :id, :id
    field :title, :string
    field :description, :string

    field :tags, list_of(:tag), resolve: dataloader(Sandbox.Dataloader)
  end

  object :recipe_queries do
    field :recipes, list_of(:recipe) do
      resolve &RecipeResolver.list/3
    end

    field :recipe, :recipe do
      arg :id, non_null(:id)

      resolve &RecipeResolver.get/3
    end

    field :search_recipes, list_of(:recipe) do
      arg :q, non_null(:string)

      resolve &RecipeResolver.search/3
    end
  end

  object :recipe_mutations do
    field :create_recipe, :recipe do
      arg :title, non_null(:string)
      arg :description, :string

      resolve &RecipeResolver.create/3
    end

    field :update_recipe, :recipe do
      arg :id, non_null(:id)
      arg :title, :string
      arg :description, :string

      resolve &RecipeResolver.update/3
    end

    field :delete_recipe, :recipe do
      arg :id, non_null(:id)

      resolve &RecipeResolver.delete/3
    end
  end
end
