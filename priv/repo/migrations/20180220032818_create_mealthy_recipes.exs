defmodule Sandbox.Repo.Migrations.CreateMealthyRecipes do
  use Ecto.Migration

  def change do
    create table(:mealthy_recipes) do
      add :title, :string
      add :description, :string

      timestamps()
    end
  end
end
