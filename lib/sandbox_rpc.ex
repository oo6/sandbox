defmodule SandboxRPC do
  @doc """
  This can be used in your application as:

      use SandboxRPC, :server, service: Sandbox.Mealthy.Recipe.Service
  """
  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      use GRPC.Server, opts

      import SandboxRPC.Helpers
    end
  end
end
