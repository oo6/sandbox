defmodule Sandbox.Mealthy.RecipeReply do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field :id, 1, type: :int32
  field :title, 2, type: :string
  field :description, 3, type: :string
end

defmodule Sandbox.Mealthy.CreateRecipeRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field :title, 1, type: :string
  field :description, 2, type: :string
end

defmodule Sandbox.Mealthy.GetRecipeRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto3

  field :id, 1, type: :int32
end

defmodule Sandbox.Mealthy.Recipe.Service do
  @moduledoc false
  use GRPC.Service, name: "sandbox.mealthy.Recipe", protoc_gen_elixir_version: "0.11.0"

  rpc :Create, Sandbox.Mealthy.CreateRecipeRequest, Sandbox.Mealthy.RecipeReply

  rpc :Get, Sandbox.Mealthy.GetRecipeRequest, Sandbox.Mealthy.RecipeReply
end

defmodule Sandbox.Mealthy.Recipe.Stub do
  @moduledoc false
  use GRPC.Stub, service: Sandbox.Mealthy.Recipe.Service
end