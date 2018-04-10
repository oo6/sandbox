defmodule Sandbox.Repo.Migrations.CreateVehiclePhotos do
  use Ecto.Migration

  def change do
    create table(:vehicle_photos) do
      add(:name, :string)
      add(:standard_urls, :map)
      add(:facebook_urls, :map)
      add(:craigslist_urls, :map)

      timestamps()
    end
  end
end
