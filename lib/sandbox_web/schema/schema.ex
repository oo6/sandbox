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

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(
        Sandbox.Dataloader,
        Dataloader.Ecto.new(Sandbox.Repo, query: &dataloader_query/2)
      )

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  # 如果有自定义 query 查询，请添加 Source 然后在相应的 Context 中处理
  defp dataloader_query(query, _params), do: query
end
