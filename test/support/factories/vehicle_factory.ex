defmodule Sandbox.VehicleFactory do
  use ExMachina.Ecto, repo: Sandbox.Repo

  alias Sandbox.Vehicle.Photo

  def photo_factory do
    %Photo{}
  end
end
