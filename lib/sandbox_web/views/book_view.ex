defmodule SandboxWeb.BookView do
  use SandboxWeb, :view

  alias Sandbox.BookStore.Book

  def render("index.json", %{books: books}) do
    %{items: Enum.map(books, &book_json/1)}
  end

  def render("show.json", %{book: book}) do
    book_json(book)
  end

  def book_json(%Book{} = book) do
    book
    |> Map.take([:id, :title, :subtitle, :author, :quantity])
    |> Map.put(:price, book.price && Money.to_string(book.price))
  end
end
