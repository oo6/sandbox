defmodule SandboxWeb.BookController do
  use SandboxWeb, :controller

  alias Sandbox.BookStore
  alias Sandbox.BookStore.Book

  def index(conn, params) do
    books = apply(BookStore, func_name(params, "list_books"), [])
    render(conn, "index.json", books: books)
  end

  def show(conn, %{"id" => id} = params) do
    BookStore
    |> apply(func_name(params, "get_book"), [id])
    |> case do
      %Book{} = book ->
        render(conn, "show.json", book: book)

      _ ->
        conn |> put_status(404) |> json(%{error: "Not found"})
    end
  end

  def order(conn, %{"book_id" => book_id} = params) do
    BookStore
    |> apply(func_name(params, "order_book"), [book_id])
    |> case do
      {:ok, _book} ->
        conn |> put_status(201) |> json(%{status: "Order placed"})

      {:error, :no_copies_available} ->
        json(conn, %{status: "Not enough copies on hand to complete order"})

      {:error, :not_found} ->
        conn |> put_status(404) |> json(%{error: "Not found"})
    end
  end

  defp func_name(%{"mode" => "repo"}, name), do: :"repo_#{name}"
  defp func_name(_, name), do: :"actor_#{name}"
end
