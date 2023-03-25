defmodule SandboxRPC.Endpoint do
  use GRPC.Endpoint

  intercept GRPC.Logger.Server
  intercept GRPCEcto.Server.RenderErrors

  run SandboxRPC.RecipeServer
end
