defmodule Sandbox.Vehicle.Photo do
  use Sandbox, :schema

  schema "vehicle_photos" do
    field(:name, :string)

    embeds_one :standard_urls, StandardUrls, on_replace: :update do
      field(:extra_large, :string)
      field(:extra_small, :string)
      field(:large, :string)
      field(:medium, :string)
      field(:original_large, :string)
      field(:small, :string)
    end

    embeds_one :facebook_urls, FacebookUrls, on_replace: :update do
      field(:hero_ad, :string)
      field(:carousel_ad, :string)
    end

    embeds_one :craigslist_urls, CraigslistUrls, on_replace: :update do
      field(:ad, :string)
    end

    timestamps()
  end
end
