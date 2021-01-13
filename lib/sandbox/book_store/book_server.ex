defmodule Sandbox.BookStore.BookServer do
  use GenServer

  alias Sandbox.Repo
  alias Sandbox.BookStore.{Book, BookRegistry}
  alias Ecto.Changeset

  def start_link(book) do
    GenServer.start_link(__MODULE__, book, name: {:via, Registry, {BookRegistry, book.id}})
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:order, _from, %{quantity: 0} = state) do
    {:reply, :no_copies_available, state}
  end

  def handle_call(:order, _from, %{quantity: quantity} = state) do
    state
    |> Book.order_changeset(%{quantity: quantity - 1})
    |> case do
      %Changeset{valid?: true} = changeset ->
        updated_book = Changeset.apply_changes(changeset)
        {:reply, {:ok, updated_book}, {:continue, {:persist_book_changes, changeset}}}

      error_changeset ->
        {:reply, {:error, error_changeset}, state}
    end
  end

  def handle_continue({:persist_book_changes, changeset}, state) do
    Repo.update(changeset)

    {:noreply, state}
  end
end
