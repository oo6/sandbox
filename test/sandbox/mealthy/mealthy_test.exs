defmodule Sandbox.MealthyTest do
  use Sandbox.DataCase

  import Sandbox.MealthyFactory

  alias Sandbox.Mealthy

  describe "search recipes" do
    test "support ranking, search tag, understand plurals" do
      strawberry_recipe = insert(:recipe, title: "Strawberry")
      fruit_salad_recipe = insert(:recipe, title: "Fruit Salad")
      insert(:tag, name: "strawberry", recipes: [strawberry_recipe, fruit_salad_recipe])
      insert(:tag, name: "salad", recipes: [fruit_salad_recipe])

      assert [strawberry_recipe, fruit_salad_recipe] == Mealthy.search_recipes(q: "strawberry")
      assert [strawberry_recipe, fruit_salad_recipe] == Mealthy.search_recipes(q: "strawberries")
    end

    test "support substring matches" do
      recipe = insert(:recipe, title: "Butternut Squash Soup")
      assert [recipe] == Mealthy.search_recipes(q: "bu")
    end

    test "ignore accents" do
      recipe = insert(:recipe, title: "Saute Vegetable")
      assert [recipe] == Mealthy.search_recipes(q: "sauté")
    end
  end
end
