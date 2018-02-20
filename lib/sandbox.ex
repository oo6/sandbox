defmodule Sandbox do
  @moduledoc """
  Sandbox keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def context do
    quote do
      import Ecto.Query
      alias Ecto.Multi
      alias Sandbox.Repo
    end
  end

  def schema do
    quote do
      use Ecto.Schema
      import Ecto.{Changeset, Query}
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
