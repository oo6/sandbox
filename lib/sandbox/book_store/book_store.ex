defmodule Sandbox.BookStore do
  use Sandbox, :context

  alias Sandbox.BookStore.Book

  def create_books(params) do
    time = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    params =
      Enum.map(
        params,
        &[{:quantity, &1[:price] && 500}, {:inserted_at, time}, {:updated_at, time} | &1]
      )

    Repo.insert_all(Book, params, on_conflict: :replace_all, conflict_target: :title)
  end
end
