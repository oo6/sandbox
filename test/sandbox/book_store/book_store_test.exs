defmodule Sandbox.BookStoreTest do
  use Sandbox.DataCase

  alias Sandbox.BookStore
  alias Sandbox.BookStore.Book

  test "create books" do
    assert {2, [%Book{quantity: nil}, %Book{quantity: 500}]} =
             BookStore.create_books([
               [title: "Hello, World!", author: "Brian Kernighan"],
               [
                 title: "The C programming Language",
                 author: "Brian Kernighan, Dennis Ritchie",
                 price: Money.new(1000, :USD)
               ]
             ])
  end
end
