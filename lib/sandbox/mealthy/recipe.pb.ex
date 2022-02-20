defmodule Sandbox.Mealthy.RecipeReply do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: integer,
          title: String.t(),
          description: String.t()
        }

  defstruct id: 0,
            title: "",
            description: ""

  field :id, 1, type: :int32
  field :title, 2, type: :string
  field :description, 3, type: :string
end

defmodule Sandbox.Mealthy.CreateRecipeRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          title: String.t(),
          description: String.t()
        }

  defstruct title: "",
            description: ""

  field :title, 1, type: :string
  field :description, 2, type: :string
end

defmodule Sandbox.Mealthy.GetRecipeRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: integer
        }

  defstruct id: 0

  field :id, 1, type: :int32
end

defmodule Sandbox.Mealthy.Recipe.Service do
  @moduledoc false
  use GRPC.Service, name: "sandbox.mealthy.Recipe"

  rpc(:Create, Sandbox.Mealthy.CreateRecipeRequest, Sandbox.Mealthy.RecipeReply)

  rpc(:Get, Sandbox.Mealthy.GetRecipeRequest, Sandbox.Mealthy.RecipeReply)
end

defmodule Sandbox.Mealthy.Recipe.Stub do
  @moduledoc false
  use GRPC.Stub, service: Sandbox.Mealthy.Recipe.Service
end
