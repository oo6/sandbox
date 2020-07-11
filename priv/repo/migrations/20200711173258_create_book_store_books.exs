defmodule Sandbox.Repo.Migrations.CreateBookStoreBooks do
  use Ecto.Migration

  def change do
    create table(:book_store_books, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :subtitle, :string
      add :author, :string
      add :price, :money_with_currency
      add :quantity, :integer

      timestamps()
    end

    create index(:book_store_books, [:title], unique: true)
  end
end
