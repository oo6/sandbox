defmodule Sandbox.Repo.Migrations.CreateMealthyTags do
  use Ecto.Migration

  def change do
    create table(:mealthy_tags) do
      add :name, :string

      timestamps()
    end
  end
end
