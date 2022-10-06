defmodule Sandbox.VentureTest do
  use Sandbox.DataCase

  import Sandbox.VentureFactory

  alias Sandbox.Venture
  alias Sandbox.Venture.NPC

  describe "list npcs" do
    test "" do
      assert insert_list(5, :npc) == Venture.list_npcs()
    end

    test "by level" do
      npcs = insert_list(5, :npc, level: 5)
      insert(:npc)

      filter = [{:level, :gte, 4}, {:level, :lte, 6}]
      assert npcs == Venture.list_npcs(filter: filter)
    end

    test "by tag" do
      npcs = insert_list(5, :npc, tags: ["junior"])
      insert(:npc)

      assert npcs == Venture.list_npcs(filter: [{:tag, &NPC.filter_by/3, "junior"}])
    end
  end
end
