defmodule Sandbox.BookStore.Book do
  use Sandbox, :schema

  @derive {Jason.Encoder, only: [:title, :subtitle, :author, :quantity]}

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

  def order_changeset(book, attrs) do
    cast(book, attrs, [:quantity])
  end
end
