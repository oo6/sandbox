defmodule Sandbox.Repo.Migrations.CreateVentureNpcs do
  use Ecto.Migration

  def change do
    create table(:venture_npcs) do
      add :name, :string
      add :level, :integer
      add :tags, {:array, :string}
      add :description, :string

      timestamps()
    end
  end
end
