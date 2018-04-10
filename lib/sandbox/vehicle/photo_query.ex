defmodule Sandbox.Vehicle.PhotoQuery do
  import Ecto.Query

  defmacro photo_urls_have_a_null do
    quote do
      fragment("""
      (facebook_urls->>'hero_ad' IS NULL)
      OR (facebook_urls->>'carousel_ad' IS NULL)
      OR (craigslist_urls->>'ad' IS NULL)
      """)
    end
  end

  defmacro photo_urls_not_contain([hero_ad_value, carousel_ad_value, ad_value]) do
    quote do
      fragment(
        """
        (facebook_urls->>'hero_ad' NOT ILIKE ?)
        OR (facebook_urls->>'carousel_ad' NOT ILIKE ?)
        OR (craigslist_urls->>'ad' NOT ILIKE ?)
        """,
        ^"%#{unquote(hero_ad_value)}%",
        ^"%#{unquote(carousel_ad_value)}%",
        ^"%#{unquote(ad_value)}%"
      )
    end
  end
end
