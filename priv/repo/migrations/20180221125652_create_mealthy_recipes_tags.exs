defmodule Sandbox.Repo.Migrations.CreateMealthyRecipesTags do
  use Ecto.Migration

  def change do
    create table(:mealthy_recipes_tags, primary_key: false) do
      add(:recipe_id, references(:mealthy_recipes))
      add(:tag_id, references(:mealthy_tags))

      timestamps()
    end
  end
end
