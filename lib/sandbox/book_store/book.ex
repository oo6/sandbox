defmodule Sandbox.BookStore.Book do
  use Sandbox, :schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "book_store_books" do
    field :title, :string
    field :subtitle, :string
    field :author, :string
    field :price, Money.Ecto.Composite.Type
    field :quantity, :integer

    timestamps()
  end
end
