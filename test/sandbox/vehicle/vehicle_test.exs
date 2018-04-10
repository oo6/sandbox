defmodule Sandbox.VehicleTest do
  use Sandbox.DataCase

  alias Sandbox.Vehicle

  import Sandbox.VehicleFactory

  describe "list_bad_photos" do
    test "have_a_null" do
      photo_1 =
        insert(
          :photo,
          facebook_urls: %{hero_ad: "facebook_hero_ad"},
          craigslist_urls: %{ad: "ad"}
        )

      photo_2 =
        insert(
          :photo,
          facebook_urls: %{carousel_ad: "facebook_carousel_ad"},
          craigslist_urls: %{ad: "ad"}
        )

      photo_3 =
        insert(
          :photo,
          facebook_urls: %{hero_ad: "facebook_hero_ad", carousel_ad: "facebook_carouse_ad"}
        )

      assert [photo_1, photo_2, photo_3] == Vehicle.list_bad_photos()
    end

    test "not_contain" do
      photo_1 =
        insert(
          :photo,
          facebook_urls: %{hero_ad: "hero_ad", carousel_ad: "facebook_carouse_ad"},
          craigslist_urls: %{ad: "craigslist_ad"}
        )

      photo_2 =
        insert(
          :photo,
          facebook_urls: %{hero_ad: "facebook_hero_ad", carousel_ad: "carouse_ad"},
          craigslist_urls: %{ad: "craigslist_ad"}
        )

      photo_3 =
        insert(
          :photo,
          facebook_urls: %{hero_ad: "facebook_hero_ad", carousel_ad: "facebook_carouse_ad"},
          craigslist_urls: %{ad: "ad"}
        )

      assert [photo_1, photo_2, photo_3] == Vehicle.list_bad_photos()
    end
  end
end
