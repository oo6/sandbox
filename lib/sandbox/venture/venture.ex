defmodule Sandbox.Venture do
  use Sandbox, :context

  alias Sandbox.Filter
  alias Sandbox.Venture.NPC

  def list_npcs(opts \\ []) do
    opts = Enum.into(opts, %{})

    NPC
    |> Filter.apply(opts[:filter])
    |> Repo.all()
  end
end
