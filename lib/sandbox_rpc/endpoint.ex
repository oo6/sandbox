defmodule SandboxRPC.Endpoint do
  use GRPC.Endpoint

  intercept GRPC.Logger.Server
  run SandboxRPC.RecipeServer
end
