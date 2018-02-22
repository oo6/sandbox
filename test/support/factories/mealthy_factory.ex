defmodule Sandbox.MealthyFactory do
  use ExMachina.Ecto, repo: Sandbox.Repo

  alias Sandbox.Mealthy.{Recipe, Tag}

  def recipe_factory do
    %Recipe{}
  end

  def tag_factory do
    %Tag{}
  end
end
