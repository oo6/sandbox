defmodule Sandbox.BookStore do
  use Sandbox, :context

  alias Sandbox.BookStore.{Book, BookSupervisor}

  def create_books(params) do
    time = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    params =
      Enum.map(
        params,
        &[{:quantity, &1[:price] && 500}, {:inserted_at, time}, {:updated_at, time} | &1]
      )

    Repo.insert_all(Book, params, on_conflict: :replace_all, conflict_target: :title)
  end

  def actor_list_books() do
    BookSupervisor.all_pids()
    |> Enum.reduce([], fn pid, acc ->
      case GenServer.call(pid, :get) do
        %Book{} = book -> [book | acc]
        _ -> acc
      end
    end)
  end

  def actor_get_book(id) do
    id
    |> BookSupervisor.get_pid()
    |> case do
      {:ok, pid} -> GenServer.call(pid, :get)
      error -> error
    end
  end

  def actor_order_book(id) do
    id
    |> BookSupervisor.get_pid()
    |> case do
      {:ok, pid} -> GenServer.call(pid, :order)
      error -> error
    end
  end

  def repo_list_books() do
    Repo.all(Book)
  end

  def repo_get_book(id) do
    Repo.get(Book, id)
  end

  def repo_order_book(id) do
    Repo.transaction(fn ->
      case repo_get_book(id) do
        %Book{quantity: 0} ->
          {:error, :no_copies_available}

        %Book{quantity: quantity} = book ->
          book
          |> Book.order_changeset(%{quantity: quantity - 1})
          |> Repo.update()

        _ ->
          {:error, :not_found}
      end
    end)
  end
end
