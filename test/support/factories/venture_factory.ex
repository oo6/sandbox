defmodule Sandbox.VentureFactory do
  use ExMachina.Ecto, repo: Sandbox.Repo

  alias Sandbox.Venture.NPC

  def npc_factory do
    %NPC{}
  end
end
