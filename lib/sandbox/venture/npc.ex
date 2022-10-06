defmodule Sandbox.Venture.NPC do
  use Sandbox, :schema

  alias Sandbox.Filter

  @behaviour Filter

  schema "venture_npcs" do
    field :name, :string
    field :level, :integer, default: 0
    field :tags, {:array, :string}, default: []
    field :description, :string

    timestamps()
  end

  @impl Filter
  def filter_by(query, :tag, value) do
    query |> where([n], fragment("? @> ?::varchar[]", n.tags, [^value]))
  end

  def changeset(npc, attrs) do
    npc
    |> cast(attrs, [:name, :level, :tags, :description])
    |> validate_required([:name])
  end
end
