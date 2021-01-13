defmodule Sandbox.BookStore.BookStateHydrator do
  use GenServer, restart: :transient

  require Logger

  alias Sandbox.BookStore
  alias Sandbox.BookStore.{Book, BookSupervisor}

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__, timeout: 10_000)
  end

  @impl true
  def init(_) do
    Logger.info("#{inspect(Time.utc_now())} Starting Books process hydration")

    BookStore.repo_list_books()
    |> Enum.each(fn %Book{} = book ->
      BookSupervisor.add_book_to_supervisor(book)
    end)

    Logger.info("#{inspect(Time.utc_now())} Completed Books process hydration")

    :ignore
  end
end
