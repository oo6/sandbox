defmodule SandboxWeb.Schema do
  use Absinthe.Schema

  alias SandboxWeb.Schema.Mealthy

  import_types Mealthy.{RecipeTypes, TagTypes}

  query do
    import_fields :recipe_queries
  end

  mutation do
    import_fields :recipe_mutations
  end
end
