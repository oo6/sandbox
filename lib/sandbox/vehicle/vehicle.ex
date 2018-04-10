defmodule Sandbox.Vehicle do
  use Sandbox, :context

  alias Sandbox.Vehicle.Photo

  import Sandbox.Vehicle.PhotoQuery

  def list_bad_photos do
    from(
      Photo,
      where: photo_urls_have_a_null(),
      or_where:
        photo_urls_not_contain([
          "facebook_hero_ad",
          "facebook_carouse_ad",
          "craigslist_ad"
        ])
    )
    |> Repo.all()
  end
end
