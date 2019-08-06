defmodule SandboxWeb.Schema.Mealthy.TagTypes do
  use Absinthe.Schema.Notation

  object :tag do
    field :name, :string
  end
end
