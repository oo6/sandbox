defmodule SandboxWeb.Schema do
  use Absinthe.Schema

  alias SandboxWeb.Schema.Mealthy.{RecipeTypes, TagTypes}

  import_types RecipeTypes
  import_types TagTypes

  query do
    import_fields :recipe_queries
  end

  mutation do
    import_fields :recipe_mutations
  end
end
