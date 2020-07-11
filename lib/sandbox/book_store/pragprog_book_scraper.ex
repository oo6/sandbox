defmodule Sandbox.BookStore.PragprogBookScraper do
  alias Sandbox.BookStore

  @host "https://pragprog.com"

  def run(path \\ "/titles/") do
    body = path |> get_page()
    body |> get_books() |> BookStore.create_books()

    if path = get_next_page_path(body) do
      run(path)
    end
  end

  def get_page(path) do
    %{body: body} = HTTPoison.get!(@host <> path)
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
