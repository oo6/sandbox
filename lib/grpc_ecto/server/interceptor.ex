defmodule GRPCEcto.Server.Interceptor do
  defprotocol Exception do
    @spec status(t) :: GRPC.Status.t()
    def status(exception)

    @spec status(t) :: String.t()
    def message(exception)
  end
end

defimpl GRPCEcto.Server.Interceptor.Exception, for: Ecto.NoResultsError do
  def status(_), do: GRPC.Status.not_found()
  def message(%Ecto.NoResultsError{message: message}), do: message
end

defimpl GRPCEcto.Server.Interceptor.Exception, for: Any do
  def status(_), do: GRPC.Status.unknown()
  def message(_), do: "Internal Server Error"
end
