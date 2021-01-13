:rand.seed(:exrop, {1, 2, 3})
:inets.start()
:ssl.start()

total_requests = 2_000
concurrency = 20

book_ids = Sandbox.BookStore.repo_list_books() |> Enum.map(& &1.id)

request_book_ids =
  1..ceil(total_requests / length(book_ids))
  |> Enum.reduce([], fn _, acc ->
    acc ++ book_ids
  end)
  |> Enum.shuffle()
  |> Enum.take(total_requests)
  |> Enum.zip(1..total_requests)

host = "http://localhost:4000"

request_book_ids
|> Task.async_stream(
  fn {book_id, count} ->
    case rem(count, 3) do
      0 ->
        url = "#{host}/api/books"
        :httpc.request(:get, {url, []}, [], [])

      1 ->
        url = "#{host}/api/books/#{book_id}"
        :httpc.request(:get, {url, []}, [], [])

      2 ->
        url = "#{host}/api/books/#{book_id}/order"
        :httpc.request(:post, {url, [], 'application/json', '{}'}, [], [])
    end
  end,
  max_concurrency: concurrency
)
|> Stream.run()
