defmodule Sandbox.BookStore.PragprogBookScraper do
  use Tesla, only: [:get], docs: false

  plug Tesla.Middleware.BaseUrl, "https://pragprog.com"
  plug Tesla.Middleware.Logger, debug: false

  alias Sandbox.BookStore

  def run(path \\ "/titles/") do
    body = get_page(path)
    body |> get_books() |> BookStore.create_books()

    if path = get_next_page_path(body) do
      run(path)
    end
  end

  def get_page(path) do
    %{body: body} = get!(path)
    Floki.parse_document!(body)
  end

  def get_next_page_path(body) do
    body
    |> Floki.find(".pagination-link")
    |> List.last()
    |> Floki.attribute("href")
    |> List.first()
  end

  def get_books(body) do
    body
    |> Floki.find(".category-title-container")
    |> Floki.attribute("a", "href")
    |> Task.async_stream(&get_book/1, max_concurrency: 5, timeout: 30_000)
    |> Enum.reduce([], fn {:ok, book}, acc -> [book | acc] end)
  end

  def get_book(path) do
    partial = path |> get_page() |> Floki.find(".book-main")

    Enum.map(
      [:title, :subtitle, :author, :price],
      &{&1, apply(__MODULE__, :"get_#{&1}", partial)}
    )
  end

  def get_title(partial) do
    partial
    |> Floki.find(".title")
    |> Floki.text(deep: false)
    |> String.trim()
  end

  def get_subtitle(partial) do
    partial
    |> Floki.find(".subtitle")
    |> Floki.text(deep: false)
    |> String.trim()
  end

  def get_author(partial) do
    partial
    |> Floki.find(".author")
    |> Floki.text(deep: false)
    |> String.replace_prefix("by", "")
    |> String.trim()
  end

  def get_price(partial) do
    money =
      partial
      |> Floki.find(".buy-container strong")
      |> Floki.text(deep: false)

    if money != "", do: Money.parse!(money, :USD)
  end
end
