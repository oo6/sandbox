defmodule Sandbox.BookStore.BookSupervisor do
  use DynamicSupervisor

  alias Sandbox.BookStore.{BookServer, BookRegistry}

  def start_link(opts) do
    DynamicSupervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def add_book_to_supervisor(book) do
    child_spec = %{
      id: BookServer,
      start: {BookServer, :start_link, [book]},
      restart: :transient
    }

    {:ok, _pid} = DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def all_pids do
    __MODULE__
    |> DynamicSupervisor.which_children()
    |> Enum.reduce([], fn {_, book_pid, _, _}, acc ->
      [book_pid | acc]
    end)
  end

  def get_pid(book_id) do
    case Registry.lookup(BookRegistry, book_id) do
      [{book_pid, _}] -> {:ok, book_pid}
      _ -> {:error, :not_found}
    end
  end
end
