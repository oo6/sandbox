defmodule Sandbox.Repo.Migrations.CreateMealthyRecipeSearch do
  use Ecto.Migration

  def up do
    execute("CREATE EXTENSION IF NOT EXISTS unaccent")
    execute("CREATE EXTENSION IF NOT EXISTS pg_trgm")

    execute("""
    CREATE MATERIALIZED VIEW mealthy_recipe_search AS
    SELECT
    mealthy_recipes.id AS id,
    mealthy_recipes.title AS title,
    (
      setweight(to_tsvector(unaccent(mealthy_recipes.title)), 'A') ||
      setweight(to_tsvector(unaccent(coalesce(string_agg(mealthy_tags.name, ' '), ' '))), 'B')
    ) AS document
    FROM mealthy_recipes
    LEFT JOIN mealthy_recipes_tags ON mealthy_recipes_tags.recipe_id = mealthy_recipes.id
    LEFT JOIN mealthy_tags ON mealthy_tags.id = mealthy_recipes_tags.tag_id
    GROUP BY mealthy_recipes.id
    """)

    # to support full-text searches
    create(index(:mealthy_recipe_search, [:document], using: :gin))
    # to support substring title matches with ILIKE
    execute("""
    CREATE INDEX mealthy_recipe_search_title_index
    ON mealthy_recipe_search
    USING gin (title gin_trgm_ops)
    """)

    # to support updating CONCURRENTLY
    create(unique_index(:mealthy_recipe_search, [:id], name: :mealthy_recipe_search_pkey))

    execute("""
    CREATE OR REPLACE FUNCTION refresh_recipe_search()
    RETURNS TRIGGER LANGUAGE plpgsql
    AS $$
    BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY mealthy_recipe_search;
    RETURN NULL;
    END $$;
    """)

    execute("""
    CREATE TRIGGER refresh_recipe_search
    AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE
    ON mealthy_recipes
    FOR EACH STATEMENT
    EXECUTE PROCEDURE refresh_recipe_search();
    """)

    execute("""
    CREATE TRIGGER refresh_recipe_search
    AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE
    ON mealthy_recipes_tags
    FOR EACH STATEMENT
    EXECUTE PROCEDURE refresh_recipe_search();
    """)

    execute("""
    CREATE TRIGGER refresh_recipe_search
    AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE
    ON mealthy_tags
    FOR EACH STATEMENT
    EXECUTE PROCEDURE refresh_recipe_search();
    """)
  end

  def down do
    execute("DROP TRIGGER refresh_recipe_search ON mealthy_recipes")
    execute("DROP TRIGGER refresh_recipe_search ON mealthy_recipes_tags")
    execute("DROP TRIGGER refresh_recipe_search ON mealthy_tags")
    execute("DROP FUNCTION refresh_recipe_search()")

    execute("DROP MATERIALIZED VIEW mealthy_recipe_search")

    execute("DROP EXTENSION unaccent")
    execute("DROP EXTENSION pg_trgm")
  end
end
