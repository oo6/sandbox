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
  def filter_by_attr({:level_from, level}, query) do
    query |> where([n], n.level >= ^level)
  end

  def filter_by_attr({:level_to, level}, query) do
    query |> where([n], n.level <= ^level)
  end

  def filter_by_attr({:tag, value}, query) do
    query |> where([n], fragment("? @> ?::varchar[]", n.tags, [^value]))
  end

  def filter_by_attr(_, query), do: query

  def changeset(npc, attrs) do
    npc
    |> cast(attrs, [:name, :level, :tags, :description])
    |> validate_required([:name])
  end
end
