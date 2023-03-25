defmodule GRPCEcto.Server.RenderErrors do
  @behaviour GRPC.ServerInterceptor

  alias GRPCEcto.Server.Interceptor

  @impl true
  def init(opts), do: opts

  @impl true
  def call(req, stream, next, _opts) do
    try do
      next.(req, stream)
    catch
      :error, reason ->
        raise GRPC.RPCError,
          status: Interceptor.Exception.status(reason),
          message: Interceptor.Exception.message(reason)
    end
  end
end
