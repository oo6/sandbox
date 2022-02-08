defmodule Sandbox.Repo do
  use Ecto.Repo,
    otp_app: :sandbox,
    adapter: Ecto.Adapters.Postgres

  def listen(event_name) do
    with {:ok, pid} <- Postgrex.Notifications.start_link(config()),
         {:ok, ref} <- Postgrex.Notifications.listen(pid, event_name) do
      {:ok, pid, ref}
    end
  end
end
