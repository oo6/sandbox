defmodule SandboxWeb.Schema.Helpers do
  alias Sandbox.Repo

  def preload(key, struts) do
    struts
    |> Repo.preload(key)
    |> Map.new(&{&1.id, Map.get(&1, key)})
  end
end
